// GameScene.swift

import SpriteKit

class GameScene: SKScene {

    var playerPaddle: SKSpriteNode!
    var opponentPaddle: SKSpriteNode!
    var ball: SKSpriteNode!

    override func didMove(to view: SKView) {
        setupGame()
    }

    func setupGame() {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)

        playerPaddle = SKSpriteNode(color: .white, size: CGSize(width: 10, height: 100))
        playerPaddle.position = CGPoint(x: frame.minX + 20, y: frame.midY)
        playerPaddle.physicsBody = SKPhysicsBody(rectangleOf: playerPaddle.size)
        playerPaddle.physicsBody?.isDynamic = false
        addChild(playerPaddle)

        opponentPaddle = SKSpriteNode(color: .white, size: CGSize(width: 10, height: 100))
        opponentPaddle.position = CGPoint(x: frame.maxX - 20, y: frame.midY)
        opponentPaddle.physicsBody = SKPhysicsBody(rectangleOf: opponentPaddle.size)
        opponentPaddle.physicsBody?.isDynamic = false
        addChild(opponentPaddle)

        ball = SKSpriteNode(color: .white, size: CGSize(width: 10, height: 10))
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        ball.physicsBody = SKPhysicsBody(rectangleOf: ball.size)
        ball.physicsBody?.velocity = CGVector(dx: 200, dy: 200)
        addChild(ball)

        let scoreLabel = SKLabelNode(text: "0 - 0")
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 20)
        addChild(scoreLabel)
    }

    override func update(_ currentTime: TimeInterval) {
        // Move the player paddle
        if playerPaddle.position.y < ball.position.y {
            playerPaddle.position.y += 5
        } else if playerPaddle.position.y > ball.position.y {
            playerPaddle.position.y -= 5
        }

        // Bounce the ball off the paddles and top/bottom of screen
        if ball.position.x <= frame.minX + 10 {
            print("Player scores!")
            ball.position = CGPoint(x: frame.midX, y: frame.midY)
            ball.physicsBody?.velocity = CGVector(dx: 200, dy: 200)
        } else if ball.position.x >= frame.maxX - 10 {
            print("Opponent scores!")
            ball.position = CGPoint(x: frame.midX, y: frame.midY)
            ball.physicsBody?.velocity = CGVector(dx: -200, dy: -200)
        }

        if ball.position.y <= frame.minY + 10 || ball.position.y >= frame.maxY - 10 {
            ball.physicsBody?.velocity.dy *= -1
        }
    }

    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 126:
            playerPaddle.position.y += 20
        case 125:
            playerPaddle.position.y -= 20
        default:
            break
        }
    }
}

