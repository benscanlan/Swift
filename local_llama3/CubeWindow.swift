import AppKit

class CubeWindow: NSWindowController {
    override func windowDidLoad() {
        super.windowDidLoad()
        
        let view = NSView(frame: NSRect(x: 0, y: 0, width: 200, height: 200))
        
        // Draw a simple cube
        view.layer?.backgroundColor = .white
        
        let path = NSBezierPath()
        path.move(to: NSPoint(x: 50, y: 50))
        path.line(to: NSPoint(x: 150, y: 50))
        path.line(to: NSPoint(x: 150, y: 150))
        path.line(to: NSPoint(x: 50, y: 150))
        path.close()
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.strokeColor = .black
        shape.lineWidth = 2
        
        view.layer?.addSublayer(shape)
        
        window?.contentView = view
    }
}

// Create the main application delegate
class AppDelegate: NSObject, NSApplicationDelegate {
    var windowController: CubeWindow?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        windowController = CubeWindow(window: nil)
        windowController?.window?.makeKeyAndOrderFront(nil)
    }
}

// Create the application and run it
let app = NSApplication.shared()
app.setActivationPolicy(.regular)

let delegate = AppDelegate()
app.delegate = delegate

app.run()

