import SpriteKit
import TGCore

public final class TileGameScene: SKScene {
    private let game: GameLoop
    private let node: GameNode
    
    public init(coordinateConverter: CoordinateConverter) {
        game = GameLoop()
        node = .init(
            gameLoop: game,
            coordinateConverter: coordinateConverter
        )
        super.init(size: coordinateConverter.calculateSize())
        anchorPoint = .zero
        scaleMode = .aspectFit
        addChild(node)
        self.backgroundColor = .clear
        node.start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches
            .map { $0.location(in: self) }
            .forEach(node.onTouch(atPosition:))
    }
}
