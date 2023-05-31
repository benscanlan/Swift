//
//  _dmaze1App.swift
//  3dmaze1
//
//  Created by Ben Scanlan on 4/14/23.
//

//import SwiftUI
//
//@main
//struct _dmaze1App: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}
import SwiftUI
import SpriteKit
@main
struct GameSceneView: UIViewRepresentable {
    func makeUIView(context: Context) -> SKView {
        let skView = SKView()
        
        // Create an instance of the GameScene
        let scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        // Present the scene in the SKView
        skView.presentScene(scene)
        
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        // Update the view if needed
    }
}

struct ContentView: View {
    var body: some View {
        GameSceneView()
            .frame(width: 400, height: 600)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
