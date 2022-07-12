import SpriteKit
import TGCore


final class BoardNode: SKNode {
    private var currentNodes: [[SKShapeNode]] = []
    
    func draw(rows: [[Tile]], boardSize: BoardSize) {
        guard let totalSceneWidth = scene?.frame.width
        else { return }
        let hexagonRadius: CGFloat = totalSceneWidth / CGFloat(boardSize.width)  / 2
        
        currentNodes = rows.enumerated()
            .map { (j, row) in
                row
                    .enumerated()
                    .map { (i, tile) -> SKShapeNode in
                        let node = SKShapeNode(hexagonOfRadius: hexagonRadius)
                        switch tile {
                        case .empty:
                            node.fillColor = .clear
                        case .exit:
                            node.fillColor = .brown
                        case .floor:
                            node.fillColor = .blue
                        }
                        node.fillColor = .red
                        
                        node.strokeColor = .random
                        node.lineWidth = 2
                        
                        return node
                }
            }
        
        for j in 0..<boardSize.height {
            let row = SKNode()
            var screenPosition: CGPoint!
            for i in 0..<boardSize.width {
                let boardPosition = CGPoint(x: i, y: j)
                screenPosition = convert(boardPosition, fromBoardWithHexagonRadius: hexagonRadius)
                let node = currentNodes[j][i]
                node.position.x = screenPosition.x
                row.addChild(node)
                debugPrint(boardPosition, screenPosition)
            }
            
            addChild(row)
            row.position.y = screenPosition.y + 10
        }
        
    }
    
    func draw(playerAt position: TilePosition) {
        
    }
    
    private func convert(
        _ point: CGPoint,
        fromBoardWithHexagonRadius radius: CGFloat
    ) -> CGPoint {
        let height = sqrt(3) * radius / 2
        let xSpacing: CGFloat = 0
        let ySpacing: CGFloat = 0
        
        let x = xSpacing + radius + point.x * 2 * radius
        let y = height + point.y * 2 * height + point.y * ySpacing
        return .init(
            x: x,
            y: y
        )
    }
}

 public final class GameNode: SKNode {
    private let boardNode: BoardNode = .init()
    private let playerNode: SKSpriteNode = .init()
    
    public override init() {
        super.init()
        addChild(boardNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func render(level: Level) {
        boardNode.draw(rows: level.board.rows, boardSize: level.board.size)
        if let playerPosition = level.playerPosition {
            boardNode.draw(playerAt: playerPosition)
        }
    }
}

extension SKShapeNode {
    convenience init(hexagonOfRadius radius: CGFloat) {
        self.init(path: .hexagon(radius: radius))
        lineWidth = 0
    }
}

extension CGPath {
    static func hexagon(radius: CGFloat) -> CGPath {
        let sides: CGFloat = 6
        let angle = CGFloat.pi * 2 / sides
        let path = CGMutablePath()
        path.move(to: .init(x: radius, y: 0))
        
        var points = [CGPoint]()
        
        for i in stride(from: 0.0, through: sides - 1, by: 1) {
            let pX = radius * cos(angle * i)
            let pY = radius * sin(angle * i)
            points.append(CGPoint(x: pX, y: pY))
        }
        
        path.addLines(between: points)
        path.closeSubpath()
        return path.copy()!
    }
}

extension UIColor {
    static var random: UIColor {
        UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1
        )
    }
}
