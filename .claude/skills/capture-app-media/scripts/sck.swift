// sck: capture WallCal over the bare wallpaper (no other windows).
// usage: sck shot <out.png> | sck rec <out.mov> <seconds>
import AVFoundation
import CoreGraphics
import Foundation
import ImageIO
import ScreenCaptureKit
import UniformTypeIdentifiers

let args = CommandLine.arguments

func filter() async throws -> (SCContentFilter, SCStreamConfiguration) {
    let content = try await SCShareableContent.excludingDesktopWindows(false, onScreenWindowsOnly: true)
    let display = content.displays.first { $0.displayID == CGMainDisplayID() }!
    let windows = content.windows.filter {
        $0.owningApplication?.applicationName == "WallCal" || $0.owningApplication?.applicationName == "bgwin"
    }
    let f = SCContentFilter(display: display, including: windows)
    let c = SCStreamConfiguration()
    c.width = display.width * 2
    c.height = display.height * 2
    c.showsCursor = false
    c.capturesAudio = false
    return (f, c)
}

class Recorder: NSObject, SCRecordingOutputDelegate {
    func recordingOutputDidFinishRecording(_ r: SCRecordingOutput) { print("finished") }
    func recordingOutput(_ r: SCRecordingOutput, didFailWithError e: Error) { print("fail", e) }
}

let sem = DispatchSemaphore(value: 0)
Task {
    do {
        let (f, c) = try await filter()
        if args[1] == "shot" {
            let img = try await SCScreenshotManager.captureImage(contentFilter: f, configuration: c)
            let dest = CGImageDestinationCreateWithURL(URL(fileURLWithPath: args[2]) as CFURL, UTType.png.identifier as CFString, 1, nil)!
            CGImageDestinationAddImage(dest, img, nil)
            CGImageDestinationFinalize(dest)
            print("saved", img.width, img.height)
        } else {
            c.minimumFrameInterval = CMTime(value: 1, timescale: 60)
            let stream = SCStream(filter: f, configuration: c, delegate: nil)
            let rc = SCRecordingOutputConfiguration()
            rc.outputURL = URL(fileURLWithPath: args[2])
            rc.outputFileType = .mov
            rc.videoCodecType = .hevc
            let rec = Recorder()
            let out = SCRecordingOutput(configuration: rc, delegate: rec)
            try stream.addRecordingOutput(out)
            try await stream.startCapture()
            print("recording")
            try await Task.sleep(for: .seconds(Double(args[3])!))
            try await stream.stopCapture()
            try await Task.sleep(for: .seconds(1))
        }
    } catch { print("error", error) }
    sem.signal()
}
sem.wait()
