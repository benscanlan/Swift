import Cocoa
import SpriteKit

// MARK: - Game Scene
class IsometricGameScene: SKScene {
    private let gridSize = 10
    private let tileWidth: CGFloat = 64
    private let tileHeight: CGFloat = 32
    
    private var selectedBuildingType = "🏢"
    private var highlightNode: SKShapeNode?
    private var buildings: [[SKLabelNode?]] = []
    
    override func didMove(to view: SKView) {
        backgroundColor = .darkGray
        setupGrid()
        setupBuildings()
    }
    
    private func setupGrid() {
        // Create the isometric grid
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                let tile = createTile(row: row, col: col)
                addChild(tile)
            }
        }
        
        // Initialize highlight node
        highlightNode = SKShapeNode()
        if let highlight = highlightNode {
            highlight.strokeColor = .yellow
            highlight.lineWidth = 2
            highlight.isHidden = true
            addChild(highlight)
        }
    }
    
    private func setupBuildings() {
        buildings = Array(repeating: Array(repeating: nil, count: gridSize), count: gridSize)
    }
    
    private func createTile(row: Int, col: Int) -> SKShapeNode {
        let tile = SKShapeNode()
        let path = CGMutablePath()
        
        // Calculate isometric coordinates
        let isoX = CGFloat(col - row) * tileWidth / 2
        let isoY = CGFloat(col + row) * tileHeight / 2
        
        // Create diamond shape
        path.move(to: CGPoint(x: isoX, y: isoY + tileHeight/2))
        path.addLine(to: CGPoint(x: isoX + tileWidth/2, y: isoY))
        path.addLine(to: CGPoint(x: isoX, y: isoY - tileHeight/2))
        path.addLine(to: CGPoint(x: isoX - tileWidth/2, y: isoY))
        path.closeSubpath()
        
        tile.path = path
        tile.strokeColor = .white
        tile.fillColor = (row + col) % 2 == 0 ? .lightGray : .white
        tile.alpha = 0.5
        
        // Center the grid
        tile.position = CGPoint(x: size.width/2, y: size.height/2)
        
        return tile
    }
    
    private func isometricToGrid(point: CGPoint) -> (row: Int, col: Int)? {
        // Convert screen coordinates to isometric coordinates
        let localPoint = CGPoint(x: point.x - size.width/2, y: point.y - size.height/2)
        
        let x = localPoint.x / tileWidth
        let y = localPoint.y / tileHeight
        
        let row = Int((y - x))
        let col = Int((y + x))
        
        if row >= 0 && row < gridSize && col >= 0 && col < gridSize {
            return (row, col)
        }
        return nil
    }
    
    private func placeBuilding(at position: (row: Int, col: Int)) {
        // Remove existing building if any
        buildings[position.row][position.col]?.removeFromParent()
        
        // Create new building
        let building = SKLabelNode(text: selectedBuildingType)
        building.fontSize = 30
        
        // Calculate position
        let isoX = CGFloat(position.col - position.row) * tileWidth / 2
        let isoY = CGFloat(position.col + position.row) * tileHeight / 2
        building.position = CGPoint(x: size.width/2 + isoX, y: size.height/2 + isoY)
        
        addChild(building)
        buildings[position.row][position.col] = building
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.characters?.first {
        case "1": selectedBuildingType = "🏢"
        case "2": selectedBuildingType = "🏠"
        case "3": selectedBuildingType = "🌳"
        default: break
        }
    }
    
    override func mouseMoved(with event: NSEvent) {
        let location = event.location(in: self)
        if let gridPosition = isometricToGrid(point: location) {
            // Update highlight
            let isoX = CGFloat(gridPosition.col - gridPosition.row) * tileWidth / 2
            let isoY = CGFloat(gridPosition.col + gridPosition.row) * tileHeight / 2
            
            let path = CGMutablePath()
            path.move(to: CGPoint(x: isoX, y: isoY + tileHeight/2))
            path.addLine(to: CGPoint(x: isoX + tileWidth/2, y: isoY))
            path.addLine(to: CGPoint(x: isoX, y: isoY - tileHeight/2))
            path.addLine(to: CGPoint(x: isoX - tileWidth/2, y: isoY))
            path.closeSubpath()
            
            highlightNode?.path = path
            highlightNode?.position = CGPoint(x: size.width/2, y: size.height/2)
            highlightNode?.isHidden = false
            
            print("Hovering over tile: (\(gridPosition.row), \(gridPosition.col))")
        } else {
            highlightNode?.isHidden = true
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        if let gridPosition = isometricToGrid(point: location) {
            placeBuilding(at: gridPosition)
            print("Placed \(selectedBuildingType) at (\(gridPosition.row), \(gridPosition.col))")
        }
    }
}

// MARK: - App Delegate
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let windowSize = NSSize(width: 800, height: 600)
        
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: windowSize.width, height: windowSize.height),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        
        let view = SKView(frame: NSRect(x: 0, y: 0, width: windowSize.width, height: windowSize.height))
        window.contentView = view
        
        let scene = IsometricGameScene(size: windowSize)
        scene.scaleMode = .aspectFit
        view.presentScene(scene)
        
        window.center()
        window.makeKeyAndOrderFront(nil)
    }
}

// MARK: - Main
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
