
import Foundation
import Cocoa
import Metal
import MetalKit

// MARK: - Game Renderer
class Renderer: NSObject, MTKViewDelegate {
    var device: MTLDevice
    var commandQueue: MTLCommandQueue
    
    init(metalView: MTKView) {
        guard let dev = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal is not supported")
        }
        device = dev
        
        guard let queue = device.makeCommandQueue() else {
            fatalError("Could not create command queue")
        }
        commandQueue = queue
        
        super.init()
        
        metalView.device = device
        metalView.delegate = self
        metalView.clearColor = MTLClearColor(red: 0.2, green: 0.3, blue: 0.4, alpha: 1.0)
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // Handle window resize if needed
    }
    
    func draw(in view: MTKView) {
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let descriptor = view.currentRenderPassDescriptor,
              let drawable = view.currentDrawable else { return }
        
        // Create command encoder for rendering
        let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        
        // Add your rendering commands here
        
        commandEncoder?.endEncoding()
        
        // Present the drawable to the screen
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}

// MARK: - Window Controller
class GameWindowController: NSWindowController {
    var renderer: Renderer!
    
    init(width: Int, height: Int) {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: width, height: height),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        super.init(window: window)
        
        window.title = "Metal Game"
        window.center()
        
        // Create Metal view
        let metalView = MTKView(frame: window.contentView!.bounds)
        window.contentView = metalView
        
        // Initialize renderer
        renderer = Renderer(metalView: metalView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - App Delegate
class AppDelegate: NSObject, NSApplicationDelegate {
    var windowController: GameWindowController!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        windowController = GameWindowController(width: 800, height: 600)
        windowController.showWindow(nil)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

// MARK: - Main Menu Setup
func setupMainMenu() {
    let mainMenu = NSMenu()
    
    let appMenuItem = NSMenuItem()
    mainMenu.addItem(appMenuItem)
    
    let appMenu = NSMenu()
    appMenuItem.submenu = appMenu
    
    appMenu.addItem(withTitle: "Quit",
                    action: #selector(NSApplication.terminate(_:)),
                    keyEquivalent: "q")
    
    NSApp.mainMenu = mainMenu
}

// MARK: - Main
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.regular)
setupMainMenu()
app.activate(ignoringOtherApps: true)
app.run()
