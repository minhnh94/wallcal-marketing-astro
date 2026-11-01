// og: render the 1200x630 social card (2x, downscale with sips). Driven by og.sh.
// usage: og <icon.png> <screenshot.jpg> <out.png> [headA headEm headB tagline size cjkFont]
import AppKit

let args = CommandLine.arguments
let W: CGFloat = 1200, H: CGFloat = 630, S: CGFloat = 2  // render at 2x, downscale later

let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(W * S), pixelsHigh: Int(H * S), bitsPerSample: 8, samplesPerPixel: 4,
                           hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
rep.size = NSSize(width: W, height: H)
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
let ctx = NSGraphicsContext.current!.cgContext
let space = CGColorSpaceCreateDeviceRGB()

func rgb(_ hex: Int, _ a: CGFloat = 1) -> CGColor {
    CGColor(red: CGFloat((hex >> 16) & 255) / 255, green: CGFloat((hex >> 8) & 255) / 255, blue: CGFloat(hex & 255) / 255, alpha: a)
}

// Backdrop: same palette as the capture wallpaper.
let base = CGGradient(colorsSpace: space, colors: [rgb(0x2A1638), rgb(0x1B1A3F), rgb(0x0F2A44)] as CFArray, locations: [0, 0.55, 1])!
ctx.drawLinearGradient(base, start: CGPoint(x: 0, y: H), end: CGPoint(x: W, y: 0), options: [])
for (x, y, r, c, a) in [(0.05, 0.95, 0.65, 0xFF8A4C, 0.75), (0.95, 0.95, 0.5, 0xFF5E7E, 0.5), (0.85, 0.0, 0.7, 0x2FB8CF, 0.55), (0.1, 0.0, 0.6, 0x6C5CE7, 0.7)] as [(CGFloat, CGFloat, CGFloat, Int, CGFloat)] {
    let g = CGGradient(colorsSpace: space, colors: [rgb(c, a), rgb(c, 0)] as CFArray, locations: [0, 1])!
    let p = CGPoint(x: x * W, y: y * H)
    ctx.drawRadialGradient(g, startCenter: p, startRadius: 0, endCenter: p, endRadius: r * W, options: [])
}

// Screenshot, bleeding off the right and bottom edges.
let shot = NSImage(contentsOfFile: args[2])!
let shotW: CGFloat = 760
let shotH = shotW * shot.size.height / shot.size.width
let shotRect = NSRect(x: 560, y: H - 96 - shotH, width: shotW, height: shotH)
let clip = NSBezierPath(roundedRect: shotRect, xRadius: 22, yRadius: 22)
NSGraphicsContext.saveGraphicsState()
let sh = NSShadow(); sh.shadowBlurRadius = 50; sh.shadowOffset = NSSize(width: 0, height: -20); sh.shadowColor = NSColor.black.withAlphaComponent(0.45); sh.set()
NSColor(white: 0.1, alpha: 1).setFill(); clip.fill()
NSGraphicsContext.restoreGraphicsState()
NSGraphicsContext.saveGraphicsState()
clip.addClip()
shot.draw(in: shotRect)
NSGraphicsContext.restoreGraphicsState()
NSColor(white: 1, alpha: 0.28).setStroke()
let border = NSBezierPath(roundedRect: shotRect.insetBy(dx: 0.5, dy: 0.5), xRadius: 22, yRadius: 22); border.lineWidth = 1; border.stroke()

// Copy.
func attr(_ s: String, _ font: NSFont, _ color: NSColor, kern: CGFloat = 0) -> NSAttributedString {
    NSAttributedString(string: s, attributes: [.font: font, .foregroundColor: color, .kern: kern])
}
let icon = NSImage(contentsOfFile: args[1])!
icon.draw(in: NSRect(x: 64, y: H - 64 - 64, width: 64, height: 64))
attr("WallCal", .systemFont(ofSize: 30, weight: .semibold), .white, kern: -0.6).draw(at: NSPoint(x: 140, y: H - 64 - 48))

func arg(_ i: Int, _ d: String) -> String { args.count > i ? args[i].replacingOccurrences(of: "\\n", with: "\n") : d }
let size = CGFloat(Double(arg(8, "62"))!)
let cjk = args.count > 9 ? NSFont(name: args[9], size: size) : nil
let sans = cjk ?? NSFont.systemFont(ofSize: size, weight: .bold)
let serif = cjk ?? NSFont(descriptor: NSFont.systemFont(ofSize: size + 4, weight: .regular).fontDescriptor.withDesign(.serif)!
    .withSymbolicTraits(.italic), size: size + 4)!
let kern: CGFloat = cjk == nil ? -2.2 : 0
let headline = NSMutableAttributedString()
headline.append(attr(arg(4, "Your calendar,\n"), sans, .white, kern: kern))
headline.append(attr(arg(5, "right on"), serif, NSColor(red: 1, green: 0.62, blue: 0.52, alpha: 1), kern: cjk == nil ? -1 : 0))
headline.append(attr(arg(6, " your\nwallpaper."), sans, .white, kern: kern))
let para = NSMutableParagraphStyle(); para.lineHeightMultiple = cjk == nil ? 0.92 : 1.1
headline.addAttribute(.paragraphStyle, value: para, range: NSRange(location: 0, length: headline.length))
headline.draw(in: NSRect(x: 62, y: 190, width: 520, height: 270))

attr(arg(7, "Free on the Mac App Store · Included with Setapp"), args.count > 9 ? NSFont(name: args[9], size: 21)! : .systemFont(ofSize: 21, weight: .medium), NSColor(white: 1, alpha: 0.75))
    .draw(at: NSPoint(x: 64, y: 72))

NSGraphicsContext.restoreGraphicsState()
try! rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: args[3]))
