// bgwin: full-screen branded gradient just above the system wallpaper, so captures don't depend on the user's wallpaper.
import AppKit

final class GradientView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        guard let ctx = NSGraphicsContext.current?.cgContext else { return }
        let w = bounds.width, h = bounds.height
        let space = CGColorSpaceCreateDeviceRGB()
        func rgb(_ hex: Int, _ a: CGFloat = 1) -> CGColor {
            CGColor(red: CGFloat((hex >> 16) & 255) / 255, green: CGFloat((hex >> 8) & 255) / 255, blue: CGFloat(hex & 255) / 255, alpha: a)
        }
        // Base: deep plum to midnight blue.
        let base = CGGradient(colorsSpace: space, colors: [rgb(0x2A1638), rgb(0x1B1A3F), rgb(0x0F2A44)] as CFArray, locations: [0, 0.55, 1])!
        ctx.drawLinearGradient(base, start: CGPoint(x: 0, y: h), end: CGPoint(x: w, y: 0), options: [])
        // Soft glows, echoing the site's wallpaper gradient.
        let glows: [(CGFloat, CGFloat, CGFloat, Int, CGFloat)] = [
            (0.12, 0.85, 0.55, 0xFF8A4C, 0.62),
            (0.88, 0.88, 0.45, 0xFF5E7E, 0.50),
            (0.80, 0.08, 0.60, 0x2FB8CF, 0.50),
            (0.10, 0.05, 0.55, 0x6C5CE7, 0.60),
            (0.50, 0.50, 0.35, 0xC76BA8, 0.22),
        ]
        for (x, y, r, c, a) in glows {
            let g = CGGradient(colorsSpace: space, colors: [rgb(c, a), rgb(c, 0)] as CFArray, locations: [0, 1])!
            let center = CGPoint(x: x * w, y: y * h)
            ctx.drawRadialGradient(g, startCenter: center, startRadius: 0, endCenter: center, endRadius: r * max(w, h), options: [])
        }
        // Light ribbons, so glass refraction and blur read on camera.
        let ribbons: [(CGFloat, CGFloat, CGFloat, CGFloat)] = [(-0.35, 0.30, 1.30, 0.95), (-0.30, 0.05, 1.35, 0.80), (-0.25, -0.10, 1.40, 0.55)]
        for (i, (x0, y0, x1, y1)) in ribbons.enumerated() {
            let p = CGMutablePath()
            p.move(to: CGPoint(x: x0 * w, y: y0 * h))
            p.addCurve(to: CGPoint(x: x1 * w, y: y1 * h),
                       control1: CGPoint(x: (x0 + 0.45) * w, y: y0 * h),
                       control2: CGPoint(x: (x1 - 0.45) * w, y: y1 * h))
            ctx.addPath(p)
            ctx.setStrokeColor(rgb(0xFFFFFF, 0.10))
            ctx.setLineWidth(CGFloat(60 + i * 30))
            ctx.strokePath()
            ctx.addPath(p)
            ctx.setStrokeColor(rgb(0xFFE7D6, 0.55))
            ctx.setLineWidth(3)
            ctx.strokePath()
        }
        if CommandLine.arguments.contains("pattern") { drawPattern(ctx, w, h, rgb) }
    }

    // High-detail mode: sharp rings, stripes and a fine dot grid, so glass, transparent and blur look clearly different.
    func drawPattern(_ ctx: CGContext, _ w: CGFloat, _ h: CGFloat, _ rgb: (Int, CGFloat) -> CGColor) {
        let ringColors = [0xFF8A4C, 0xFFD23F, 0xFF5E7E, 0x6C5CE7, 0x2FB8CF]
        let sun = CGPoint(x: 0.78 * w, y: 0.35 * h)
        var r: CGFloat = 640
        var i = 0
        while r > 20 {
            ctx.setFillColor(rgb(ringColors[i % ringColors.count], 1))
            ctx.fillEllipse(in: CGRect(x: sun.x - r, y: sun.y - r, width: r * 2, height: r * 2))
            r -= 44; i += 1
        }
        let disc = CGPoint(x: 0.25 * w, y: 0.6 * h)
        ctx.saveGState()
        ctx.addEllipse(in: CGRect(x: disc.x - 480, y: disc.y - 480, width: 960, height: 960))
        ctx.clip()
        var x = disc.x - 1000
        var k = 0
        while x < disc.x + 1000 {
            ctx.setFillColor(rgb(k % 2 == 0 ? 0x2FB8CF : 0xF7F3EA, 1))
            let band = CGMutablePath()
            band.addLines(between: [CGPoint(x: x, y: disc.y - 600), CGPoint(x: x + 36, y: disc.y - 600), CGPoint(x: x + 636, y: disc.y + 600), CGPoint(x: x + 600, y: disc.y + 600)])
            ctx.addPath(band); ctx.fillPath()
            x += 36; k += 1
        }
        ctx.restoreGState()
        ctx.setFillColor(rgb(0xFFFFFF, 0.55))
        var gy: CGFloat = 0
        while gy < h {
            var gx: CGFloat = 0
            while gx < w {
                ctx.fillEllipse(in: CGRect(x: gx - 2.5, y: gy - 2.5, width: 5, height: 5))
                gx += 26
            }
            gy += 26
        }
    }
}

let app = NSApplication.shared
app.setActivationPolicy(.accessory)
let screen = NSScreen.main!
let win = NSWindow(contentRect: screen.frame, styleMask: .borderless, backing: .buffered, defer: false, screen: screen)
win.title = "DemoWallpaper"
win.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.desktopWindow)) - 1)
win.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
win.ignoresMouseEvents = true
win.contentView = GradientView(frame: screen.frame)
win.orderFront(nil)
app.run()
