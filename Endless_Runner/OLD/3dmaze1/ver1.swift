import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    private var player: SKSpriteNode!
    private var obstacle: SKSpriteNode!
    private var scoreLabel: SKLabelNode!
    
    private var score = 0
    
    override func didMove(to view: SKView) {
        // Set up physics world
        physicsWorld.contactDelegate = self
        
        // Create player node
        player = SKSpriteNode(imageNamed: "player.png")
        player.position = CGPoint(x: size.width * 0.2, y: size.height * 0.5)
        addChild(player)
        
        // Create obstacle node
        obstacle = SKSpriteNode(imageNamed: "obstacle.png")
        obstacle.position = CGPoint(x: size.width, y: size.height * 0.5)
        addChild(obstacle)
        
        // Create score label
        scoreLabel = SKLabelNode(fontNamed: "Arial")
        scoreLabel.fontSize = 30
        scoreLabel.position = CGPoint(x: size.width * 0.5, y: size.height * 0.9)
        addChild(scoreLabel)
        
        // Set up background and ground
        createBackground()
        createGround()
        
        // Start the game
        startGame()
    }
    
    func createBackground() {
        // Create and position background nodes
        // Add them as children of the scene
        // Adjust the zPosition to ensure they are behind other game elements
    }
    
    func createGround() {
        // Create and position ground nodes
        // Add them as children of the scene
    }
    
    func startGame() {
        // Reset score
        score = 0
        scoreLabel.text = "Score: \(score)"
        
        // Start obstacle movement
        let moveAction = SKAction.move(to: CGPoint(x: -obstacle.size.width, y: obstacle.position.y), duration: 5.0)
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveAction, removeAction])
        obstacle.run(sequence)
    }
    
    func jumpPlayer() {
        // Implement player jumping logic
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        jumpPlayer()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Implement game logic for scoring, collision detection, etc.
    }
    
    // Handle collisions
    func didBegin(_ contact: SKPhysicsContact) {
        // Implement collision handling logic
    }
}

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Create the scene
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .resizeFill
            
            // Present the scene
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

