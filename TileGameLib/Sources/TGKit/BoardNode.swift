import SpriteKit

import TGCore

final class BoardNode: SKNode {
    
    private let coordinateConverter: CoordinateConverter
    
    private var currentNodes: [[SKShapeNode]] = []
    private let playerNode: SKShapeNode = {
        let node = SKShapeNode(circleOfRadius: 5)
        node.strokeColor = .red
        node.zPosition = 100
        node.name = NodeProperties.Names.player
        return node
    }()
    
    init(coordinateConverter: CoordinateConverter) {
        self.coordinateConverter = coordinateConverter
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func draw(rows: [[Tile]], boardSize: BoardSize) {
        guard let totalSceneWidth = scene?.frame.width
        else { return }
        
        currentNodes.linearForEach { $0.removeFromParent() }
        currentNodes = []
        
        let hexagonRadius = coordinateConverter.radius
        
        currentNodes = rows.linearMap { makeNode(forTile: $0, hexagonRadius )}
        
        boardSize.iterate { i, j in
            let node = currentNodes[j][i]
            let boardPosition = CGPoint(x: i, y: j)
            let screenPosition = coordinateConverter.convert(boardPosition)
            node.position = screenPosition
            addChild(node)
        }
    }
    
    func draw(playerAtPosition position: TilePosition, onBoardWithSize boardSize: BoardSize) {
        if playerNode.parent == nil {
            addChild(playerNode)
        }
        guard let totalSceneWidth = scene?.frame.width
        else { return }
        let position = coordinateConverter.convert(position.cgPoint)
        playerNode.position = position
    }
    
    func tile(atPosition position: CGPoint, boardSize: BoardSize) -> TilePosition? {
        for j in 0..<currentNodes.count {
            for i in 0..<currentNodes[j].count {
                let node = currentNodes[j][i]
                if node.contains(position) {
                    return TilePosition(x: i, y: j)
                }
            }
        }
        return nil
    }
    
    private func makeNode(forTile tile: Tile, _ hexagonRadius: CGFloat) -> SKShapeNode {
           let node = SKShapeNode(hexagonOfRadius: hexagonRadius)
           node.lineWidth = 1
           
           switch tile {
           case .empty:
               node.fillColor = NodeProperties.Colors.Fill.empty
               node.strokeColor = NodeProperties.Colors.Stroke.empty
               node.name = NodeProperties.Names.empty
           case .exit:
               node.fillColor = NodeProperties.Colors.Fill.exit
               node.strokeColor = NodeProperties.Colors.Stroke.exit
               node.name = NodeProperties.Names.exit
           case .floor:
               node.fillColor = NodeProperties.Colors.Fill.floor
               node.strokeColor = NodeProperties.Colors.Stroke.floor
               node.name = NodeProperties.Names.floor
           }
           return node
    }
}
