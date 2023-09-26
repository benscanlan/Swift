import SceneKit
import QuartzCore

class GameViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a new scene
        let scene = SCNScene()
        
        // Create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // Place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // Create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // Create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = NSColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        // Create the larger sphere (Earth)
        let earth = SCNSphere(radius: 3.0)
        let earthNode = SCNNode(geometry: earth)
        earthNode.geometry?.firstMaterial?.diffuse.contents = NSColor.green
        earthNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(2 * Double.pi), z: 0, duration: 10)))
        scene.rootNode.addChildNode(earthNode)
        
        // Create the smaller sphere (satellite)
        let satellite = SCNSphere(radius: 0.5)
        let satelliteNode = SCNNode(geometry: satellite)
        satelliteNode.geometry?.firstMaterial?.diffuse.contents = NSColor.red
        satelliteNode.position = SCNVector3(x: 6, y: 0, z: 0)
        earthNode.addChildNode(satelliteNode)
        
        // Animate the satellite to orbit the Earth
        let orbitAction = SCNAction.rotateBy(x: 0, y: CGFloat(2 * Double.pi), z: 0, duration: 5)
        let repeatAction = SCNAction.repeatForever(orbitAction)
        satelliteNode.runAction(repeatAction)
        
        // Retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // Set the scene to the view
        scnView.scene = scene
        
        // Allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // Show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // Configure the view
        scnView.backgroundColor = NSColor.black
    }
}

