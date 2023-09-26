import SwiftUI
import SceneKit

struct ContentView: View {
    var body: some View {
        VStack {
            SceneView(scene: createScene())
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
                            .onChanged({ (value) in
                                panCamera(with: value)
                            })
                )
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
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 20)
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

        // Create and add a satellite (simple colored sphere) orbiting the Earth
        let satelliteNode = SCNNode(geometry: SCNSphere(radius: 0.5)) // Adjust the radius for the satellite
        satelliteNode.geometry?.firstMaterial?.diffuse.contents = NSColor.red // Red sphere for satellite
        satelliteNode.position = SCNVector3(x: 6, y: 0, z: 0)
        earthNode.addChildNode(satelliteNode)

        // Add an orbit animation to the satellite
        let orbitAction = SCNAction.rotateBy(x: 0, y: CGFloat(2 * Double.pi), z: 0, duration: 5) // Adjust duration for the orbit speed
        let repeatAction = SCNAction.repeatForever(orbitAction)
        satelliteNode.runAction(repeatAction)

        return scene
    }
}

func panCamera(with gesture: DragGesture.Value) {
        // Calculate the new camera position based on the gesture
        let translation = gesture.translation
        let anglePan = Float(translation.width) * (Float.pi / 180.0)
        let distancePan = Float(translation.height) * 0.01

        // Get the current camera node
        if let cameraNode = sceneView.pointOfView {
            // Update the camera's position
            cameraNode.position = SCNVector3(
                x: cameraNode.position.x + distancePan * sin(anglePan),
                y: cameraNode.position.y + distancePan * cos(anglePan),
                z: cameraNode.position.z
            )
        }

        // Reset the gesture translation
        gesture.translation = .zero
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
