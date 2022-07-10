import SpriteKit
import TGCore

final class BoardNode: SKNode {
    private var currentNodes: [[SKShapeNode]] = []
    
    func draw(rows: [[Tile]], boardSize: BoardSize) {
        currentNodes = rows.enumerated()
            .map { (j, row) in
                row
                    .enumerated()
                    .map { (i, tile) -> SKShapeNode in
                        let node = SKShapeNode(hexagonOfRadius: 10)
                        switch tile {
                        case .empty:
                            node.fillColor = .clear
                        case .exit:
                            node.fillColor = .brown
                        case .floor:
                            node.fillColor = .blue
                        }
                        node.fillColor = .red
                        return node
                }
            }
        
        for j in 0..<boardSize.height {
            for i in 0..<boardSize.width {
                let boardPosition = CGPoint(x: i, y: j)
                let screenPosition = convert(boardPosition, fromBoardWithHexagonRadius: 12)
                let node = currentNodes[j][i]
                node.position = screenPosition
                addChild(node)
                debugPrint(boardPosition, screenPosition)
            }
        }
        
    }
    
    func draw(playerAt position: TilePosition) {
        
    }
    
    private func convert(
        _ point: CGPoint,
        fromBoardWithHexagonRadius radius: CGFloat
    ) -> CGPoint {
        guard let scene = scene else { return .zero }
        let convert: (CGFloat) -> CGFloat = { i in
            let xSpacing: CGFloat = 0
            let spacing = i * xSpacing
            let radiiCount = radius + i * 2 * radius
            return radiiCount + spacing
        }
        print(convert(point.y))
        return .init(
            x: convert(point.x),
            y: convert(point.y)
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
