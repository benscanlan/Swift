import Cocoa
import SpriteKit

// MARK: - Constants
enum Constants {
    static let tileSize: CGFloat = 48.0  // Smaller tile size for isometric view
    static let gridWidth = 15
    static let gridHeight = 15
    static let defaultZoom: CGFloat = 1.0
    static let minZoom: CGFloat = 0.5
    static let maxZoom: CGFloat = 2.0
    
    // Isometric conversion factors
    static let isoAngle: CGFloat = .pi/6  // 30 degrees
    static let isoScale: CGFloat = 0.5
    
    enum BuildingType: String, CaseIterable {
        case empty = "⬜"
        case residential = "🏠"
        case commercial = "🏢"
        case industrial = "🏭"
        case road = "🛣️"
        
        var height: CGFloat {
            switch self {
            case .empty: return 0
            case .residential: return 2
            case .commercial: return 3
            case .industrial: return 4
            case .road: return 0.2
            }
        }
        
        var colors: (top: NSColor, left: NSColor, right: NSColor) {
            switch self {
            case .empty: return (.clear, .clear, .clear)
            case .residential: return (.systemBlue, .systemBlue.withAlphaComponent(0.7), .systemBlue.withAlphaComponent(0.5))
            case .commercial: return (.systemGreen, .systemGreen.withAlphaComponent(0.7), .systemGreen.withAlphaComponent(0.5))
            case .industrial: return (.systemOrange, .systemOrange.withAlphaComponent(0.7), .systemOrange.withAlphaComponent(0.5))
            case .road: return (.gray, .darkGray, .lightGray)
            }
        }
        
        var cost: Int {
            switch self {
            case .empty: return 0
            case .residential: return 100
            case .commercial: return 200
            case .industrial: return 300
            case .road: return 50
            }
        }
    }
}

// MARK: - Isometric Building
class IsometricBuilding: SKNode {
    let buildingType: Constants.BuildingType
    private var topFace: SKShapeNode!
    private var leftFace: SKShapeNode!
    private var rightFace: SKShapeNode!
    
    init(type: Constants.BuildingType) {
        self.buildingType = type
        super.init()
        setupBuilding()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBuilding() {
        let tileSize = Constants.tileSize
        let height = buildingType.height * tileSize
        let colors = buildingType.colors
        
        // Create isometric faces
        // Top face (diamond)
        let topPath = CGMutablePath()
        topPath.move(to: CGPoint(x: 0, y: height))
        topPath.addLine(to: CGPoint(x: tileSize/2, y: height + tileSize/4))
        topPath.addLine(to: CGPoint(x: tileSize, y: height))
        topPath.addLine(to: CGPoint(x: tileSize/2, y: height - tileSize/4))
        topPath.closeSubpath()
        
        topFace = SKShapeNode(path: topPath)
        topFace.fillColor = colors.top
        topFace.strokeColor = .white
        topFace.lineWidth = 1
        addChild(topFace)
        
        // Left face
        let leftPath = CGMutablePath()
        leftPath.move(to: CGPoint(x: 0, y: height))
        leftPath.addLine(to: CGPoint(x: tileSize/2, y: height - tileSize/4))
        leftPath.addLine(to: CGPoint(x: tileSize/2, y: -tileSize/4))
        leftPath.addLine(to: CGPoint(x: 0, y: 0))
        leftPath.closeSubpath()
        
        leftFace = SKShapeNode(path: leftPath)
        leftFace.fillColor = colors.left
        leftFace.strokeColor = .white
        leftFace.lineWidth = 1
        addChild(leftFace)
        
        // Right face
        let rightPath = CGMutablePath()
        rightPath.move(to: CGPoint(x: tileSize, y: height))
        rightPath.addLine(to: CGPoint(x: tileSize/2, y: height - tileSize/4))
        rightPath.addLine(to: CGPoint(x: tileSize/2, y: -tileSize/4))
        rightPath.addLine(to: CGPoint(x: tileSize, y: 0))
        rightPath.closeSubpath()
        
        rightFace = SKShapeNode(path: rightPath)
        rightFace.fillColor = colors.right
        rightFace.strokeColor = .white
        rightFace.lineWidth = 1
        addChild(rightFace)
        
        // Add icon on top
        let icon = SKLabelNode(text: buildingType.rawValue)
        icon.fontSize = 20
        icon.position = CGPoint(x: tileSize/2, y: height + 5)
        icon.verticalAlignmentMode = .center
        icon.horizontalAlignmentMode = .center
        addChild(icon)
    }
}

// MARK: - Isometric Grid
class IsometricGrid: SKNode {
    var tiles: [[IsometricBuilding?]] = []
    
    override init() {
        super.init()
        setupGrid()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupGrid() {
        // Initialize empty grid
        for y in 0..<Constants.gridHeight {
            var row: [IsometricBuilding?] = []
            for x in 0..<Constants.gridWidth {
                row.append(nil)
            }
            tiles.append(row)
        }
        
        // Draw grid lines
        drawGridLines()
    }
    
    private func drawGridLines() {
        let gridNode = SKNode()
        
        for y in 0...Constants.gridHeight {
            for x in 0...Constants.gridWidth {
                let worldPos = gridToWorld(x: x, y: y)
                
                if x < Constants.gridWidth {
                    let horizontalLine = SKShapeNode()
                    let path = CGMutablePath()
                    path.move(to: worldPos)
                    path.addLine(to: gridToWorld(x: x + 1, y: y))
                    horizontalLine.path = path
                    horizontalLine.strokeColor = .gray
                    horizontalLine.alpha = 0.3
                    gridNode.addChild(horizontalLine)
                }
                
                if y < Constants.gridHeight {
                    let verticalLine = SKShapeNode()
                    let path = CGMutablePath()
                    path.move(to: worldPos)
                    path.addLine(to: gridToWorld(x: x, y: y + 1))
                    verticalLine.path = path
                    verticalLine.strokeColor = .gray
                    verticalLine.alpha = 0.3
                    gridNode.addChild(verticalLine)
                }
            }
        }
        
        addChild(gridNode)
    }
    
    func gridToWorld(x: Int, y: Int) -> CGPoint {
        let isoX = (CGFloat(x) - CGFloat(y)) * Constants.tileSize/2
        let isoY = (CGFloat(x) + CGFloat(y)) * Constants.tileSize/4
        return CGPoint(x: isoX, y: isoY)
    }
    
    func worldToGrid(point: CGPoint) -> (Int, Int) {
        let x = (point.x/Constants.tileSize + 2*point.y/Constants.tileSize) / 2
        let y = (2*point.y/Constants.tileSize - point.x/Constants.tileSize) / 2
        return (Int(round(x)), Int(round(y)))
    }
    
    func placeBuilding(_ type: Constants.BuildingType, at gridPosition: (Int, Int)) -> Bool {
        guard gridPosition.0 >= 0 && gridPosition.0 < Constants.gridWidth &&
              gridPosition.1 >= 0 && gridPosition.1 < Constants.gridHeight else {
            return false
        }
        
        // Remove existing building if any
        if let existingBuilding = tiles[gridPosition.1][gridPosition.0] {
            existingBuilding.removeFromParent()
        }
        
        let building = IsometricBuilding(type: type)
        let worldPosition = gridToWorld(x: gridPosition.0, y: gridPosition.1)
        building.position = worldPosition
        addChild(building)
        
        tiles[gridPosition.1][gridPosition.0] = building
        return true
    }
}

// MARK: - Game Scene
class GameScene: SKScene {
    private var grid: IsometricGrid!
    private var cameraNode: SKCameraNode!
    private var lastPanLocation: CGPoint?
    private var selectedBuildingType: Constants.BuildingType = .residential
    private var gameState = GameState()
    private var uiLayer: SKNode!
    
    override func didMove(to view: SKView) {
        setupScene()
        setupCamera()
        setupGrid()
        setupUI()
    }
    
    private func setupScene() {
        backgroundColor = .black
    }
    
    private func setupCamera() {
        cameraNode = SKCameraNode()
        camera = cameraNode
        addChild(cameraNode)
        
        // Center the camera on the grid
        let centerX = CGFloat(Constants.gridWidth) * Constants.tileSize/4
        let centerY = CGFloat(Constants.gridHeight) * Constants.tileSize/4
        cameraNode.position = CGPoint(x: centerX, y: centerY)
        cameraNode.setScale(Constants.defaultZoom)
    }
    
    private func setupGrid() {
        grid = IsometricGrid()
        addChild(grid)
    }
    
    private func setupUI() {
        uiLayer = SKNode()
        
        // Building selection buttons
        let buttonSize = CGSize(width: 60, height: 60)
        for (index, type) in Constants.BuildingType.allCases.enumerated() {
            let button = createBuildingButton(type: type, size: buttonSize)
            button.position = CGPoint(x: -200 + CGFloat(index * 70), y: -200)
            uiLayer.addChild(button)
        }
        
        cameraNode.addChild(uiLayer)
    }
    
    private func createBuildingButton(type: Constants.BuildingType, size: CGSize) -> SKNode {
        let button = SKNode()
        
        let background = SKShapeNode(rectOf: size, cornerRadius: 5)
        background.fillColor = type.colors.top
        background.strokeColor = .white
        background.name = type.rawValue
        button.addChild(background)
        
        let label = SKLabelNode(text: type.rawValue)
        label.fontSize = 20
        label.verticalAlignmentMode = .center
        button.addChild(label)
        
        let costLabel = SKLabelNode(text: "$\(type.cost)")
        costLabel.fontSize = 12
        costLabel.position = CGPoint(x: 0, y: -size.height/2 - 10)
        button.addChild(costLabel)
        
        return button
    }
    
    // MARK: - Input Handling
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        let uiLocation = event.location(in: uiLayer)
        
        // Check UI interactions
        if let node = uiLayer.nodes(at: uiLocation).first,
           let buildingTypeString = node.name,
           let buildingType = Constants.BuildingType(rawValue: buildingTypeString) {
            selectedBuildingType = buildingType
            return
        }
        
        // Place building
        let gridPosition = grid.worldToGrid(point: location)
        if gameState.canAfford(selectedBuildingType.cost) {
            if grid.placeBuilding(selectedBuildingType, at: gridPosition) {
                gameState.purchase(selectedBuildingType.cost)
            }
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        let location = event.location(in: self)
        
        if lastPanLocation == nil {
            lastPanLocation = location
            return
        }
        
        let translation = CGPoint(
            x: location.x - lastPanLocation!.x,
            y: location.y - lastPanLocation!.y
        )
        
        cameraNode.position = CGPoint(
            x: cameraNode.position.x - translation.x,
            y: cameraNode.position.y - translation.y
        )
        
        lastPanLocation = location
    }
    
    override func mouseUp(with event: NSEvent) {
        lastPanLocation = nil
    }
    
    override func scrollWheel(with event: NSEvent) {
        let zoomFactor: CGFloat = 0.1
        let zoom = event.deltaY > 0 ? (1 + zoomFactor) : (1 - zoomFactor)
        
        let newScale = cameraNode.xScale * zoom
        if newScale >= Constants.minZoom && newScale <= Constants.maxZoom {
            cameraNode.setScale(newScale)
        }
    }
}

// MARK: - Game State
class GameState {
    var money: Int = 1000
    
    func canAfford(_ cost: Int) -> Bool {
        return money >= cost
    }
    
    func purchase(_ cost: Int) {
        money -= cost
    }
}

// MARK: - App Delegate and Main
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow?
    var gameView: SKView?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let rect = NSRect(x: 0, y: 0, width: 800, height: 600)  // Smaller window
        window = NSWindow(
            contentRect: rect,
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        
        gameView = SKView(frame: rect)
        gameView?.showsFPS = true
        gameView?.showsNodeCount = true
        gameView?.ignoresSiblingOrder = true  // Better performance
        
        window?.contentView = gameView
        
        let scene = GameScene(size: rect.size)
        scene.scaleMode = .aspectFill
        gameView?.presentScene(scene)
        
        window?.title = "Isometric City Builder"
        window?.center()
        window?.makeKeyAndOrderFront(nil)
    }
}

// Start the application
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
