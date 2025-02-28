// AppDelegate.swift

import Cocoa
import SpriteKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window = NSWindow(contentRect: NSMakeRect(100, 100, 800, 600),
                           styleMask: [.titled, .closable],
                           backing: .buffered,
                           defer: false)

        let scene = GameScene(size: CGSize(width: 800, height: 600))
        let skView = SKView(frame: window.contentRectForFrameRect(window.frame))
        skView.presentScene(scene)
        window.contentView?.addSubview(skView)
        window.makeKeyAndOrderFront(nil)
    }
}

