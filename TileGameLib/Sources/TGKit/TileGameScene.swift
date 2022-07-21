import SpriteKit
import TGCore

public final class TileGameScene: SKScene {
    private let game: GameLoopProtocol
    private let node: GameNode
    
    public convenience init(coordinateConverter: CoordinateConverter) {
        let game = GameLoop()
        let node = GameNode(
            gameLoop: game,
            coordinateConverter: coordinateConverter
        )
        self.init(
            game: game,
            node: node,
            size: coordinateConverter.calculateSize()
        )
    }
    
    init(
        game: GameLoopProtocol,
        node: GameNode,
        size: CGSize
    ) {
        self.game = game
        self.node = node
        
        super.init(size: size)
        
        anchorPoint = .zero
        scaleMode = .aspectFit
        addChild(node)
        backgroundColor = .clear
        node.start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    #if os(OSX)
    public override func mouseUp(with event: NSEvent) {
        node.onTouch(atPosition: event.location(in: self))
    }
    #else
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches
            .map { $0.location(in: self) }
            .forEach(node.onTouch(atPosition:))
    }
    #endif
}
