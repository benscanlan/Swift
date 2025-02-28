import Cocoa
import SpriteKit

// Create the application
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

// Run the application
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow?
    var gameView: SKView?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create the window
        let rect = NSRect(x: 0, y: 0, width: 800, height: 600)
        window = NSWindow(contentRect: rect,
                         styleMask: [.titled, .closable, .miniaturizable],
                         backing: .buffered,
                         defer: false)
        
        // Create the game view
        gameView = SKView(frame: rect)
        window?.contentView = gameView
        
        // Create and present the game scene
        let scene = GameScene(size: rect.size)
        scene.scaleMode = .aspectFit
        gameView?.presentScene(scene)
        
        // Show the window
        window?.title = "Sprite Game"
        window?.center()
        window?.makeKeyAndOrderFront(nil)
    }
}

