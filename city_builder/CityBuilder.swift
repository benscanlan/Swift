import Cocoa
import SpriteKit

// MARK: - Constants
enum Constants {
    static let tileSize: CGFloat = 64.0
    static let gridWidth = 20
    static let gridHeight = 15
    static let defaultZoom: CGFloat = 1.0
    static let minZoom: CGFloat = 0.5
    static let maxZoom: CGFloat = 2.0
    
    enum BuildingType: String, CaseIterable {
        case residential = "🏠"
        case commercial = "🏪"
        case industrial = "🏭"
        case road = "🛣️"
        case park = "🌳"
        case powerPlant = "⚡"
        
        var color: NSColor {
            switch self {
            case .residential: return .systemBlue
            case .commercial: return .systemGreen
            case .industrial: return .systemOrange
            case .road: return .systemGray
            case .park: return .systemTeal
            case .powerPlant: return .systemYellow
            }
        }
        
        var cost: Int {
            switch self {
            case .residential: return 100
            case .commercial: return 200
            case .industrial: return 300
            case .road: return 50
            case .park: return 75
            case .powerPlant: return 500
            }
        }
        
        var description: String {
            switch self {
            case .residential: return "Houses (Pop: +10)"
            case .commercial: return "Shops (Jobs: +5)"
            case .industrial: return "Factory (Jobs: +10)"
            case .road: return "Road (Connect)"
            case .park: return "Park (Happy: +5)"
            case .powerPlant: return "Power (Power: +50)"
            }
        }
    }
}

// MARK: - UI Elements
class InfoPanel: SKNode {
    private let background: SKShapeNode
    private let titleLabel: SKLabelNode
    private let statsLabel: SKLabelNode
    private let tipsLabel: SKLabelNode
    
    init(size: CGSize) {
        background = SKShapeNode(rectOf: size, cornerRadius: 10)
        titleLabel = SKLabelNode(text: "City Statistics")
        statsLabel = SKLabelNode(text: "")
        tipsLabel = SKLabelNode(text: "")
        
        super.init()
        setupPanel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPanel() {
        background.fillColor = .black
        background.strokeColor = .white
        background.alpha = 0.7
        addChild(background)
        
        titleLabel.fontName = "Menlo-Bold"
        titleLabel.fontSize = 16
        titleLabel.position = CGPoint(x: 0, y: 40)
        addChild(titleLabel)
        
        statsLabel.fontName = "Menlo"
        statsLabel.fontSize = 14
        statsLabel.position = CGPoint(x: 0, y: 10)
        addChild(statsLabel)
        
        tipsLabel.fontName = "Menlo"
        tipsLabel.fontSize = 12
        tipsLabel.position = CGPoint(x: 0, y: -20)
        addChild(tipsLabel)
    }
    
    func update(money: Int, population: Int, happiness: Int, power: Int) {
        statsLabel.text = "💰 $\(money) | 👥 \(population) | 😊 \(happiness) | ⚡ \(power)"
        tipsLabel.text = "Tip: Balance residential, commercial, and industrial zones"
    }
}

class BuildingButton: SKNode {
    let buildingType: Constants.BuildingType
    private let background: SKShapeNode
    private var isSelected: Bool = false
    
    init(type: Constants.BuildingType) {
        self.buildingType = type
        self.background = SKShapeNode(rectOf: CGSize(width: 80, height: 80), cornerRadius: 8)
        super.init()
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        background.fillColor = buildingType.color
        background.strokeColor = .white
        background.alpha = 0.8
        addChild(background)
        
        let emoji = SKLabelNode(text: buildingType.rawValue)
        emoji.fontSize = 30
        emoji.verticalAlignmentMode = .center
        emoji.position = CGPoint(x: 0, y: 10)
        addChild(emoji)
        
        let costLabel = SKLabelNode(text: "$\(buildingType.cost)")
        costLabel.fontSize = 12
        costLabel.fontName = "Menlo"
        costLabel.position = CGPoint(x: 0, y: -20)
        addChild(costLabel)
    }
    
    func select() {
        background.strokeColor = .yellow
        background.lineWidth = 3
        isSelected = true
    }
    
    func deselect() {
        background.strokeColor = .white
        background.lineWidth = 1
        isSelected = false
    }
}

// MARK: - Game Scene
class GameScene: SKScene {
    private var grid: [[SKSpriteNode]] = []
    private var cameraNode: SKCameraNode!
    private var lastPanLocation: CGPoint?
    private var infoPanel: InfoPanel!
    private var buildingButtons: [BuildingButton] = []
    private var gameState = GameState()
    
    override func didMove(to view: SKView) {
        setupScene()
        setupCamera()
        setupGrid()
        setupUI()
        
        // Start game loop
        let updateLoop = SKAction.sequence([
            SKAction.wait(forDuration: 1.0),
            SKAction.run { [weak self] in
                self?.updateGameLoop()
            }
        ])
        run(SKAction.repeatForever(updateLoop))
    }
    
    private func setupScene() {
        backgroundColor = .black
        physicsWorld.gravity = .zero
    }
    
    private func setupCamera() {
        cameraNode = SKCameraNode()
        camera = cameraNode
        addChild(cameraNode)
        cameraNode.setScale(Constants.defaultZoom)
    }
    
    private func setupGrid() {
        for y in 0..<Constants.gridHeight {
            var row: [SKSpriteNode] = []
            for x in 0..<Constants.gridWidth {
                let tile = SKSpriteNode(color: .darkGray, size: CGSize(width: Constants.tileSize, height: Constants.tileSize))
                tile.position = CGPoint(
                    x: CGFloat(x) * Constants.tileSize,
                    y: CGFloat(y) * Constants.tileSize
                )
                tile.alpha = 0.3
                addChild(tile)
                row.append(tile)
            }
            grid.append(row)
        }
    }
    
    private func setupUI() {
        // Info Panel
        infoPanel = InfoPanel(size: CGSize(width: 400, height: 100))
        infoPanel.position = CGPoint(x: 0, y: frame.height/2 - 60)
        cameraNode.addChild(infoPanel)
        
        // Building Buttons
        for (index, type) in Constants.BuildingType.allCases.enumerated() {
            let button = BuildingButton(type: type)
            button.position = CGPoint(x: -300 + CGFloat(index * 100), y: frame.height/2 - 150)
            cameraNode.addChild(button)
            buildingButtons.append(button)
        }
        
        updateUI()
    }
    
    private func updateUI() {
        infoPanel.update(
            money: gameState.money,
            population: gameState.population,
            happiness: gameState.happiness,
            power: gameState.power
        )
    }
    
    private func updateGameLoop() {
        gameState.updateResources()
        updateUI()
    }
    
    // MARK: - Input Handling
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        let uiLocation = event.location(in: cameraNode)
        
        // Check building button clicks
        for button in buildingButtons {
            if button.contains(uiLocation) {
                buildingButtons.forEach { $0.deselect() }
                button.select()
                gameState.selectedBuildingType = button.buildingType
                return
            }
        }
        
        // Place building
        if let buildingType = gameState.selectedBuildingType {
            attemptToBuildAt(location: location, type: buildingType)
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
    
    private func attemptToBuildAt(location: CGPoint, type: Constants.BuildingType) {
        let gridX = Int(location.x / Constants.tileSize)
        let gridY = Int(location.y / Constants.tileSize)
        
        guard gridX >= 0 && gridX < Constants.gridWidth &&
              gridY >= 0 && gridY < Constants.gridHeight else {
            return
        }
        
        if gameState.canAfford(type.cost) {
            let building = Building(type: type)
            building.position = CGPoint(
                x: CGFloat(gridX) * Constants.tileSize + Constants.tileSize/2,
                y: CGFloat(gridY) * Constants.tileSize + Constants.tileSize/2
            )
            
            addChild(building)
            gameState.purchase(type.cost)
            gameState.addBuilding(type)
            updateUI()
        }
    }
}

// MARK: - Game State
class GameState {
    var money: Int = 1000000
    var population: Int = 0
    var happiness: Int = 50
    var power: Int = 0
    var selectedBuildingType: Constants.BuildingType?
    
    private var buildingCounts: [Constants.BuildingType: Int] = [:]
    
    func canAfford(_ cost: Int) -> Bool {
        return money >= cost
    }
    
    func purchase(_ cost: Int) {
        money -= cost
    }
    
    func addBuilding(_ type: Constants.BuildingType) {
        buildingCounts[type, default: 0] += 1
        
        switch type {
        case .residential:
            population += 10
            happiness += 2
        case .commercial:
            money += 50
            happiness += 1
        case .industrial:
            money += 100
            happiness -= 1
        case .park:
            happiness += 5
        case .powerPlant:
            power += 50
        case .road:
            happiness += 1
        }
    }
    
    func updateResources() {
        // Periodic updates
        money += (buildingCounts[.commercial, default: 0] * 10)
        money += (buildingCounts[.industrial, default: 0] * 20)
        
        // Balance happiness based on city conditions
        if power < population {
            happiness -= 1
        }
        
        // Clamp values
        happiness = min(max(happiness, 0), 100)
    }
}

// MARK: - Building Class
class Building: SKSpriteNode {
    let buildingType: Constants.BuildingType
    
    init(type: Constants.BuildingType) {
        self.buildingType = type
        super.init(texture: nil, color: type.color, size: CGSize(width: Constants.tileSize * 0.9, height: Constants.tileSize * 0.9))
        setupGraphics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupGraphics() {
        let label = SKLabelNode(text: buildingType.rawValue)
        label.fontSize = 20
        label.verticalAlignmentMode = .center
        addChild(label)
    }
}

// MARK: - App Delegate and Main
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow?
    var gameView: SKView?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let rect = NSRect(x: 0, y: 0, width: 1280, height: 720)
        window = NSWindow(
            contentRect: rect,
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        
        gameView = SKView(frame: rect)
        gameView?.showsFPS = true
        gameView?.showsNodeCount = true
        
        window?.contentView = gameView
        
        let scene = GameScene(size: rect.size)
        scene.scaleMode = .aspectFill
        gameView?.presentScene(scene)
        
        window?.title = "City Builder"
        window?.center()
        window?.makeKeyAndOrderFront(nil)
    }
}

// Start the application
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)

