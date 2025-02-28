import SpriteKit
import GameplayKit

// MARK: - Constants
let GRID_WIDTH = 10
let GRID_HEIGHT = 20
let ISO_ANGLE = CGFloat.pi / 6 // 30 degrees
let BLOCK_SIZE: CGFloat = 30.0
let INITIAL_DROP_SPEED = 1.0

// MARK: - Block Class
class Block: SKSpriteNode {
    var gridX: Int = 0
    var gridY: Int = 0
    
    init(color: SKColor) {
        let size = CGSize(width: BLOCK_SIZE, height: BLOCK_SIZE)
        super.init(texture: nil, color: color, size: size)
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.restitution = 0
        self.physicsBody?.friction = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Tetromino Shapes
enum TetrominoType: CaseIterable {
    case I, O, T, S, Z, J, L
    
    var blocks: [(Int, Int)] {
        switch self {
        case .I: return [(0,0), (0,1), (0,2), (0,3)]
        case .O: return [(0,0), (1,0), (0,1), (1,1)]
        case .T: return [(0,0), (-1,0), (1,0), (0,1)]
        case .S: return [(0,0), (1,0), (0,1), (-1,1)]
        case .Z: return [(0,0), (-1,0), (0,1), (1,1)]
        case .J: return [(0,0), (0,1), (0,2), (-1,2)]
        case .L: return [(0,0), (0,1), (0,2), (1,2)]
        }
    }
    
    var color: SKColor {
        switch self {
        case .I: return .cyan
        case .O: return .yellow
        case .T: return .purple
        case .S: return .green
        case .Z: return .red
        case .J: return .blue
        case .L: return .orange
        }
    }
}

// MARK: - Game Scene
class GameScene: SKScene {
    private var grid: [[Block?]] = Array(repeating: Array(repeating: nil, count: GRID_HEIGHT), count: GRID_WIDTH)
    private var currentPiece: [Block] = []
    private var score: Int = 0
    private var gameOver = false
    private var lastUpdateTime: TimeInterval = 0
    private var dropSpeed = INITIAL_DROP_SPEED
    
    private let scoreLabel = SKLabelNode(text: "Score: 0")
    
    override func didMove(to view: SKView) {
        setupScene()
        spawnNewPiece()
    }
    
    private func setupScene() {
        backgroundColor = .black
        
        // Setup physics
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        // Setup score label
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 50)
        scoreLabel.fontColor = .white
        addChild(scoreLabel)
        
        // Add lighting
        let light = SKLightNode()
        light.position = CGPoint(x: frame.midX, y: frame.maxY)
        light.falloff = 1
        addChild(light)
    }
    
    // Convert grid coordinates to isometric screen coordinates
    private func gridToScreen(x: Int, y: Int) -> CGPoint {
        let isoX = CGFloat(x - y) * BLOCK_SIZE * cos(ISO_ANGLE)
        let isoY = CGFloat(x + y) * BLOCK_SIZE * sin(ISO_ANGLE)
        return CGPoint(x: frame.midX + isoX, y: frame.midY + isoY)
    }
    
    private func spawnNewPiece() {
        let type = TetrominoType.allCases.randomElement()!
        currentPiece = type.blocks.map { offset in
            let block = Block(color: type.color)
            block.gridX = GRID_WIDTH/2 + offset.0
            block.gridY = GRID_HEIGHT - 1 + offset.1
            block.position = gridToScreen(x: block.gridX, y: block.gridY)
            addChild(block)
            return block
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard !gameOver else { return }
        
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
            return
        }
        
        let dt = currentTime - lastUpdateTime
        if dt > dropSpeed {
            moveCurrentPiece(dx: 0, dy: -1)
            lastUpdateTime = currentTime
        }
    }
    
    private func moveCurrentPiece(dx: Int, dy: Int) {
        // Check if move is valid
        let canMove = currentPiece.allSatisfy { block in
            let newX = block.gridX + dx
            let newY = block.gridY + dy
            return isValidPosition(x: newX, y: newY)
        }
        
        if canMove {
            for block in currentPiece {
                block.gridX += dx
                block.gridY += dy
                block.position = gridToScreen(x: block.gridX, y: block.gridY)
            }
        } else if dy < 0 {
            // Piece has landed
            placePiece()
            checkLines()
            spawnNewPiece()
        }
    }
    
    private func isValidPosition(x: Int, y: Int) -> Bool {
        guard x >= 0 && x < GRID_WIDTH && y >= 0 && y < GRID_HEIGHT else { return false }
        return grid[x][y] == nil
    }
    
    private func placePiece() {
        for block in currentPiece {
            grid[block.gridX][block.gridY] = block
        }
    }
    
    private func checkLines() {
        var linesCleared = 0
        
        for y in 0..<GRID_HEIGHT {
            var complete = true
            for x in 0..<GRID_WIDTH {
                if grid[x][y] == nil {
                    complete = false
                    break
                }
            }
            
            if complete {
                clearLine(y)
                linesCleared += 1
            }
        }
        
        score += linesCleared * 100
        scoreLabel.text = "Score: \(score)"
        
        // Increase difficulty
        dropSpeed = max(0.1, INITIAL_DROP_SPEED - Double(score) / 1000)
    }
    
    private func clearLine(_ y: Int) {
        for x in 0..<GRID_WIDTH {
            grid[x][y]?.removeFromParent()
            grid[x][y] = nil
        }
        
        // Move everything down
        for yy in (y + 1)..<GRID_HEIGHT {
            for x in 0..<GRID_WIDTH {
                if let block = grid[x][yy] {
                    block.gridY -= 1
                    block.position = gridToScreen(x: block.gridX, y: block.gridY)
                    grid[x][yy-1] = block
                    grid[x][yy] = nil
                }
            }
        }
    }
    
    override func keyDown(with event: NSEvent) {
        guard !gameOver else { return }
        
        switch event.keyCode {
        case 123: // Left arrow
            moveCurrentPiece(dx: -1, dy: 0)
        case 124: // Right arrow
            moveCurrentPiece(dx: 1, dy: 0)
        case 125: // Down arrow
            moveCurrentPiece(dx: 0, dy: -1)
        case 126: // Up arrow
            rotatePiece()
        case 49: // Space
            hardDrop()
        default:
            break
        }
    }
    
    private func rotatePiece() {
        let center = currentPiece[0]
        let rotated = currentPiece.map { block in
            let dx = block.gridX - center.gridX
            let dy = block.gridY - center.gridY
            return (center.gridX - dy, center.gridY + dx)
        }
        
        if rotated.allSatisfy({ isValidPosition(x: $0.0, y: $0.1) }) {
            for (block, newPos) in zip(currentPiece, rotated) {
                block.gridX = newPos.0
                block.gridY = newPos.1
                block.position = gridToScreen(x: block.gridX, y: block.gridY)
            }
        }
    }
    
    private func hardDrop() {
        while currentPiece.allSatisfy({ isValidPosition(x: $0.gridX, y: $0.gridY - 1) }) {
            moveCurrentPiece(dx: 0, dy: -1)
        }
        placePiece()
        checkLines()
        spawnNewPiece()
    }
}

// MARK: - Game Setup
let sceneSize = CGSize(width: 1024, height: 768)
let scene = GameScene(size: sceneSize)
scene.scaleMode = .aspectFit

let view = SKView(frame: NSRect(x: 0, y: 0, width: sceneSize.width, height: sceneSize.height))
view.presentScene(scene)

let window = NSWindow(
    contentRect: view.frame,
    styleMask: [.titled, .closable, .miniaturizable],
    backing: .buffered,
    defer: false)
window.contentView = view
window.makeKeyAndOrderFront(nil)

NSApplication.shared.run()
