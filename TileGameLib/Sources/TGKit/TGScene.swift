import SpriteKit
import TGCore

final class BoardNode: SKNode {
    private var currentNodes: [[SKShapeNode]] = []
    private let playerNode: SKShapeNode = {
        let node = SKShapeNode(circleOfRadius: 5)
        node.strokeColor = .red
        
        node.zPosition = 100
        return node
    }()
    
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
                        node.fillColor = .blue
                    case .exit:
                        node.fillColor = .brown
                    case .floor:
                        node.fillColor = .black
                    }
                    
                    node.lineWidth = 1
                    
                    let debug = SKLabelNode(text: "\(i), \(j)")
                
                    debug.fontSize = 10
                    node.addChild(debug)
                    
                    return node
            }
        }
        
        for j in 0..<boardSize.height {
            for i in 0..<boardSize.width {
                let node = currentNodes[j][i]
                let boardPosition = CGPoint(x: i, y: j)
                let screenPosition = convert(
                    boardPosition,
                    fromBoardWithHexagonRadius: hexagonRadius
                )
                node.position = screenPosition
                addChild(node)
            }
        }
        
    }
    
    func draw(playerAtPosition position: TilePosition, onBoardWithSize boardSize: BoardSize) {
        if playerNode.parent == nil {
            addChild(playerNode)
        }
        
        guard let totalSceneWidth = scene?.frame.width
        else { return }
        let hexagonRadius: CGFloat = totalSceneWidth / CGFloat(boardSize.width)  / 2
        let position = convert(position.cgPoint, fromBoardWithHexagonRadius: hexagonRadius)
        playerNode.position = position
    }
    
    func tile(atPosition position: CGPoint, boardSize: BoardSize) -> TilePosition? {
        for j in 0..<boardSize.height {
            for i in 0..<boardSize.width {
                let node = currentNodes[j][i]
                if node.contains(position) {
                    return TilePosition(x: i, y: j)
                }
            }
        }
        return nil
    }
    
    private func convert(
        _ point: CGPoint,
        fromBoardWithHexagonRadius radius: CGFloat
    ) -> CGPoint {
        let width = sqrt(3) * radius
        let height = radius * 2
        let xSpacing: CGFloat = 0
        let ySpacing: CGFloat = 0
        
        var x = point.x * width + point.x * xSpacing + width / 2
        let y = point.y * height + point.y * ySpacing + height / 2
        
        if point.y.truncatingRemainder(dividingBy: 2) != 0 {
            x += width / 2
        }

        return .init(
            x: x + 10,
            y: y - (height / 4 * point.y)
        )
    }
}

public final class GameNode: SKNode {
    private let boardNode: BoardNode = .init()
    private let playerNode: SKSpriteNode = .init()

    private let gameLoop: GameLoop

    public init(gameLoop: GameLoop) {
        self.gameLoop = gameLoop
        super.init()
        addChild(boardNode)
        gameLoop.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func start() {
        gameLoop.start()
    }
    
    public func onTouch(atPosition position: CGPoint) {
        guard let tilePosition = boardNode.tile(atPosition: position, boardSize: gameLoop.level!.board.size)
        else { return }
        gameLoop.removeTile(atPosition: tilePosition)
    }
    
    public func render(level: Level?) {
        guard let level = level else { return }

        boardNode.draw(rows: level.board.rows, boardSize: level.board.size)
        
        if let playerPosition = level.playerPosition {
            boardNode.draw(
            playerAtPosition: playerPosition,
            onBoardWithSize: level.board.size
            )
        }
    }
}

extension GameNode: GameLoopDelegate {
    public func gameStateDidChange(toNewState gameState: GameState) {
        debugPrint("GAme state changed", gameState)
        render(level: gameLoop.level)
        switch gameState {
        case .notStarted:
            #warning("TODO")
        case .running:
        #warning("TODO")
        case .over:
            #warning("TODO")
        }
    }
    
    public func playerDidMove(_ level: Level, toPosition position: TilePosition) {
        render(level: gameLoop.level)
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
        let path = CGMutablePath()
        
        var points = [CGPoint]()
        
        for i in stride(from: 0.0, through: sides - 1, by: 1) {
            
            let angle = .pi / 180 * (60 * i - 30)
            let pX = radius * cos(angle)
            let pY = radius * sin(angle)
            
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
