// MARK: - Refined IsometricBuilding with better 3D appearance
class IsometricBuilding: SKNode {
    let buildingType: Constants.BuildingType
    private var faces: [SKShapeNode] = []
    private var shadow: SKShapeNode?
    
    init(type: Constants.BuildingType) {
        self.buildingType = type
        super.init()
        setupBuilding()
        addShadow()
        addDetails()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBuilding() {
        let tileSize = Constants.tileSize
        let height = buildingType.height * tileSize
        let colors = buildingType.colors
        
        // Enhanced 3D effect with more faces
        let faces = createBuildingFaces(size: tileSize, height: height)
        faces.forEach { face in
            addChild(face)
        }
        
        // Add window patterns for buildings
        if buildingType != .road {
            addWindowPattern(height: height)
        }
    }
    
    private func createBuildingFaces(size: CGFloat, height: CGFloat) -> [SKShapeNode] {
        let topFace = createTopFace(size: size, height: height)
        let leftFace = createLeftFace(size: size, height: height)
        let rightFace = createRightFace(size: size, height: height)
        
        return [topFace, leftFace, rightFace]
    }
    
    private func createTopFace(size: CGFloat, height: CGFloat) -> SKShapeNode {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: size/2, y: height + size/4))
        path.addLine(to: CGPoint(x: size, y: height))
        path.addLine(to: CGPoint(x: size/2, y: height - size/4))
        path.closeSubpath()
        
        let face = SKShapeNode(path: path)
        face.fillColor = buildingType.colors.top
        face.strokeColor = .white
        face.lineWidth = 0.5
        face.alpha = 0.9
        return face
    }
    
    private func addWindowPattern(height: CGFloat) {
        let windowSize: CGFloat = 8
        let spacing: CGFloat = 12
        
        // Add windows to left and right faces
        for y in stride(from: windowSize, to: height-windowSize, by: spacing) {
            for x in stride(from: windowSize, to: Constants.tileSize-windowSize, by: spacing) {
                let window = SKShapeNode(rectOf: CGSize(width: windowSize/2, height: windowSize))
                window.fillColor = .yellow.withAlphaComponent(0.3)
                window.strokeColor = .clear
                window.position = CGPoint(x: x, y: y)
                addChild(window)
            }
        }
    }
    
    private func addShadow() {
        let shadowPath = CGMutablePath()
        let offset: CGFloat = 5
        
        shadowPath.move(to: CGPoint(x: -offset, y: -offset))
        shadowPath.addLine(to: CGPoint(x: Constants.tileSize/2, y: -Constants.tileSize/4 - offset))
        shadowPath.addLine(to: CGPoint(x: Constants.tileSize + offset, y: -offset))
        shadowPath.addLine(to: CGPoint(x: Constants.tileSize/2, y: Constants.tileSize/4))
        shadowPath.closeSubpath()
        
        shadow = SKShapeNode(path: shadowPath)
        shadow?.fillColor = .black
        shadow?.strokeColor = .clear
        shadow?.alpha = 0.2
        shadow?.zPosition = -1
        
        if let shadow = shadow {
            addChild(shadow)
        }
    }
    
    private func addDetails() {
        // Add building-specific details
        switch buildingType {
        case .residential:
            addRoof()
        case .commercial:
            addSignage()
        case .industrial:
            addSmoke()
        case .road:
            addRoadMarkings()
        }
    }
    
    private func addRoof() {
        let roofHeight = buildingType.height * Constants.tileSize + 10
        let roofPath = CGMutablePath()
        roofPath.move(to: CGPoint(x: Constants.tileSize/2, y: roofHeight))
        roofPath.addLine(to: CGPoint(x: Constants.tileSize/2, y: roofHeight + 10))
        
        let roof = SKShapeNode(path: roofPath)
        roof.strokeColor = buildingType.colors.top
        roof.lineWidth = 2
        addChild(roof)
    }
    
    private func addSignage() {
        let sign = SKLabelNode(text: "SHOP")
        sign.fontSize = 8
        sign.fontColor = .white
        sign.position = CGPoint(x: Constants.tileSize/2, y: buildingType.height * Constants.tileSize - 10)
        addChild(sign)
    }
    
    private func addSmoke() {
        let smokeEmitter = SKEmitterNode()
        // Configure smoke particle effect
        smokeEmitter.position = CGPoint(x: Constants.tileSize/2, y: buildingType.height * Constants.tileSize)
        addChild(smokeEmitter)
    }
    
    private func addRoadMarkings() {
        let markingPath = CGMutablePath()
        markingPath.move(to: CGPoint(x: Constants.tileSize/4, y: 0))
        markingPath.addLine(to: CGPoint(x: Constants.tileSize*3/4, y: 0))
        
        let marking = SKShapeNode(path: markingPath)
        marking.strokeColor = .white
        marking.lineWidth = 2
        marking.alpha = 0.5
        addChild(marking)
    }
}

