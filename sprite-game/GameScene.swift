import SpriteKit

class GameScene: SKScene {
    private var sprite: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        // Create a simple colored square sprite
        sprite = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
        
        if let sprite = sprite {
            sprite.position = CGPoint(x: size.width/2, y: size.height/2)
            addChild(sprite)
            
            // Add a simple animation
            let moveRight = SKAction.moveBy(x: 100, y: 0, duration: 1.0)
            let moveLeft = SKAction.moveBy(x: -100, y: 0, duration: 1.0)
            let sequence = SKAction.sequence([moveRight, moveLeft])
            let repeatForever = SKAction.repeatForever(sequence)
            
            sprite.run(repeatForever)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        // Change sprite color on click
        sprite?.color = .blue
    }
}

