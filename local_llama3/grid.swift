import SpriteKit

class Grid: SKSpriteNode {
    var rows: Int = 10
    var cols: Int = 10
    var cellSize: CGFloat = 50
    
    override init() {
        super.init()
        
        for row in 0...rows {
            for col in 0...cols {
                let cell = SKSpriteNode(color: .white, size: CGSize(width: cellSize, height: cellSize))
                cell.position = CGPoint(x: CGFloat(col) * cellSize, y: CGFloat(row) * cellSize)
                addChild(cell)
            }
        }
    }
}

class Building: SKShapeNode {
    override init() {
        super.init()
        
        let rect = CGRect(x: 0, y: 0, width: 50, height: 50)
        path = UIBezierPath(rect: rect).cgPath
        fillColor = .red
    }
}

class GameScene: SKScene {
    var grid: Grid!
    var buildings: [Building] = []
    
    override func didMove(to view: SKView) {
        grid = Grid()
        addChild(grid)
        
        let building = Building()
        buildings.append(building)
        grid.addChild(building)
    }
}

