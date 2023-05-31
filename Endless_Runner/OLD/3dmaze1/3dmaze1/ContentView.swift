//
//  ContentView.swift
//  3dmaze1
//
//  Created by Ben Scanlan on 4/14/23.
//
import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Player node
    var player: SKSpriteNode!
    
    // Ground node
    var ground: SKSpriteNode!
    
    // Obstacle node
    var obstacle: SKSpriteNode!
    
    // Score label
    var scoreLabel: SKLabelNode!
    var score = 0
    
    // Category bitmask
    let playerCategory: UInt32 = 0x1 << 0
    let obstacleCategory: UInt32 = 0x1 << 1
    
    override func didMove(to view: SKView) {
        // Set up physics world
        physicsWorld.contactDelegate = self
        
        // Create player node
        player = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50))
        player.position = CGPoint(x: -150, y: 0)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.collisionBitMask = obstacleCategory
        addChild(player)
        
        // Create ground node
        ground = SKSpriteNode(color: .gray, size: CGSize(width: frame.width, height: 50))
        ground.position = CGPoint(x: frame.midX, y: -frame.height/2 + ground.size.height/2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = obstacleCategory
        ground.physicsBody?.collisionBitMask = playerCategory
        addChild(ground)
        
        // Create score label
        scoreLabel = SKLabelNode(fontNamed: "Arial")
        scoreLabel.fontSize = 24
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.height/2 - 50)
        addChild(scoreLabel)
        
        // Start spawning obstacles
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(spawnObstacle), SKAction.wait(forDuration: 1.5)])))
    }
    
    func spawnObstacle() {
        // Create obstacle node
        obstacle = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
        obstacle.position = CGPoint(x: frame.width/2 + obstacle.size.width/2, y: -frame.height/2 + ground.size.height + obstacle.size.height/2)
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.affectedByGravity = false
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.categoryBitMask = obstacleCategory
        obstacle.physicsBody?.collisionBitMask = playerCategory
        addChild(obstacle)
        
        // Move obstacle across the screen
        let moveAction = SKAction.move(to: CGPoint(x: -frame.width/2 - obstacle.size.width/2, y: obstacle.position.y), duration: 4.0)
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveAction, removeAction])
        obstacle.run(sequence)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == obstacleCategory ||
            contact.bodyA.categoryBitMask == obstacleCategory && contact.bodyB.categoryBitMask == playerCategory {
            gameOver()
        }
    }
    
    func gameOver() {
            // Stop spawning obstacles
            removeAllActions()
            
            // Show game over label
            let gameOverLabel = SKLabelNode(fontNamed: "Arial")
            gameOverLabel.fontSize = 36
            gameOverLabel.text = "Game Over"
            gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
            addChild(gameOverLabel)
        }
    
} //end

