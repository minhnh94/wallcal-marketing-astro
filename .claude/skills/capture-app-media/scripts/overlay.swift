// overlay: render 1920x1080 transparent PNG overlays for the demo video.
// usage: overlay caption <out.png> <eyebrow> <text>
//        overlay card <out.png> <icon.png> <title> <subtitle> [footnote]
import AppKit

let W: CGFloat = 1920, H: CGFloat = 1080
let args = CommandLine.arguments

func render(_ out: String, _ draw: () -> Void) {
    let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(W), pixelsHigh: Int(H), bitsPerSample: 8, samplesPerPixel: 4,
                               hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
    draw()
    NSGraphicsContext.restoreGraphicsState()
    try! rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: out))
}

func text(_ s: String, size: CGFloat, weight: NSFont.Weight, color: NSColor, kern: CGFloat = 0) -> NSAttributedString {
    let p = NSMutableParagraphStyle(); p.alignment = .center
    return NSAttributedString(string: s, attributes: [.font: NSFont.systemFont(ofSize: size, weight: weight), .foregroundColor: color, .kern: kern, .paragraphStyle: p])
}

func shadowed(_ block: () -> Void) {
    let sh = NSShadow(); sh.shadowBlurRadius = 30; sh.shadowColor = NSColor.black.withAlphaComponent(0.35); sh.shadowOffset = NSSize(width: 0, height: -8)
    NSGraphicsContext.saveGraphicsState(); sh.set(); block(); NSGraphicsContext.restoreGraphicsState()
}

switch args[1] {
case "caption":
    let eyebrow = text(args[3].uppercased(), size: 20, weight: .semibold, color: NSColor(red: 1, green: 0.62, blue: 0.52, alpha: 1), kern: 2.4)
    let body = text(args[4], size: 40, weight: .semibold, color: .white, kern: -0.6)
    let bw = max(eyebrow.size().width, body.size().width) + 88
    let bh: CGFloat = 132
    let rect = NSRect(x: (W - bw) / 2, y: 64, width: bw, height: bh)
    render(args[2]) {
        shadowed {
            NSColor(white: 0.08, alpha: 0.62).setFill()
            NSBezierPath(roundedRect: rect, xRadius: 34, yRadius: 34).fill()
        }
        NSColor(white: 1, alpha: 0.18).setStroke()
        let border = NSBezierPath(roundedRect: rect.insetBy(dx: 0.75, dy: 0.75), xRadius: 34, yRadius: 34); border.lineWidth = 1.5; border.stroke()
        eyebrow.draw(in: NSRect(x: rect.minX, y: rect.maxY - 50, width: bw, height: 30))
        body.draw(in: NSRect(x: rect.minX, y: rect.minY + 22, width: bw, height: 56))
    }

case "card":
    let icon = NSImage(contentsOfFile: args[3])!
    let title = text(args[4], size: 92, weight: .bold, color: .white, kern: -3)
    let sub = text(args[5], size: 40, weight: .medium, color: NSColor(white: 1, alpha: 0.85), kern: -0.4)
    let foot = args.count > 6 ? text(args[6], size: 26, weight: .medium, color: NSColor(white: 1, alpha: 0.7)) : nil
    render(args[2]) {
        shadowed { icon.draw(in: NSRect(x: (W - 200) / 2, y: 610, width: 200, height: 200)) }
        shadowed {
            title.draw(in: NSRect(x: 0, y: 470, width: W, height: 120))
            sub.draw(in: NSRect(x: 0, y: 400, width: W, height: 60))
            foot?.draw(in: NSRect(x: 0, y: 320, width: W, height: 40))
        }
    }

default:
    print("unknown")
}
