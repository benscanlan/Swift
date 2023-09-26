import SwiftUI
import SceneKit

struct ContentView: View {
    var body: some View {
        VStack {
            SceneView(scene: createScene(), options: [.allowsCameraControl])
                .edgesIgnoringSafeArea(.all)
                .frame(width: 400, height: 400)
        }
    }

    func createScene() -> SCNScene {
        // Create a new scene
        let scene = SCNScene()

        // Create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        scene.rootNode.addChildNode(cameraNode)

        // Create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)

        // Create and add a rotating Earth model (simple colored sphere)
        let earthNode = SCNNode(geometry: SCNSphere(radius: 3.0))
        earthNode.geometry?.firstMaterial?.diffuse.contents = NSColor.green // Green sphere for Earth
        earthNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(2 * Double.pi), z: 0, duration: 10)))
        scene.rootNode.addChildNode(earthNode)

        // Create and add a satellite model (simple colored sphere)
        let satelliteNode = SCNNode(geometry: SCNSphere(radius: 0.2))
        satelliteNode.geometry?.firstMaterial?.diffuse.contents = NSColor.red // Red sphere for satellite
        satelliteNode.position = SCNVector3(x: 6, y: 0, z: 0)
        scene.rootNode.addChildNode(satelliteNode)

        return scene
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

