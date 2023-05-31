import SwiftUI
import SceneKit

struct ContentView: View {
    var body: some View {
        SceneKitView()
    }
}

struct SceneKitView: UIViewRepresentable {
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        
        // Create a camera node
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 5)
        
        // Create a light node
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        
        // Create a scene and add the camera and light nodes to it
        let scene = SCNScene()
        scene.rootNode.addChildNode(cameraNode)
        scene.rootNode.addChildNode(lightNode)
        
        // Create a maze using boxes
        let mazeWidth = 8
        let mazeHeight = 8
        let mazeDepth = 8
        
        for x in 0..<mazeWidth {
            for y in 0..<mazeHeight {
                for z in 0..<mazeDepth {
                    if x == 0 || y == 0 || z == 0 || x == mazeWidth-1 || y == mazeHeight-1 || z == mazeDepth-1 {
                        // Add a wall at the maze boundary
                        let wallGeometry = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
                        let wallNode = SCNNode(geometry: wallGeometry)
                        wallNode.position = SCNVector3(x, y, z)
                        scene.rootNode.addChildNode(wallNode)
                    } else if x % 2 == 0 && y % 2 == 0 && z % 2 == 0 {
                        // Add a wall at even grid points to create maze paths
                        let wallGeometry = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
                        let wallNode = SCNNode(geometry: wallGeometry)
                        wallNode.position = SCNVector3(x, y, z)
                        scene.rootNode.addChildNode(wallNode)
                    }
                }
            }
        }
        
        // Add a player node to the scene
        let playerGeometry = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0)
        let playerNode = SCNNode(geometry: playerGeometry)
        playerNode.position = SCNVector3(x: 1, y: 1, z: 1)
        scene.rootNode.addChildNode(playerNode)
        
        // Implement player controls using gestures
        var lastLocation: CGPoint?
        
        sceneView.addGestureRecognizer(UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePanGesture(_:))))
        
        class Coordinator: NSObject {
            let sceneView: SCNView
            let playerNode: SCNNode
            
            init(sceneView: SCNView, playerNode: SCNNode) {
                self.sceneView = sceneView
                self.playerNode = playerNode
            }
            
            @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
                let location = gestureRecognizer.location(in: sceneView)
                
                switch gestureRecognizer.state {


