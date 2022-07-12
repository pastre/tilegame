import SwiftUI
import SpriteKit

import TGCore
import TGKit

final class TileGameScene: SKScene {
    private var board: Board {
        var rows: [[Tile]] = .init(repeating: .init(repeating: .floor, count: 8), count: 8)
        rows[0][4] = .exit
        return .init(rows: rows, size: 8)
    }
    private lazy var game = GameLoop(levelFactory: .debug(board: board))
    private lazy var node = GameNode(gameLoop: game)
    
    override init(size: CGSize) {
        super.init(size: size)
        anchorPoint = .zero
        scaleMode = .aspectFit
        backgroundColor = .white
        addChild(node)
        
        node.start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches
            .map { $0.location(in: self) }
            .forEach(node.onTouch(atPosition:))
    }
    
}

@main
struct TileGameApp: App {
    
    var body: some Scene {
        WindowGroup {
            VStack {
                Spacer()
                gameView
                Spacer()
            }
        }
    }
    
    private var gameView: some View {
        GeometryReader { proxy in
            SpriteView(scene: TileGameScene(size: proxy.size.square()))
        }
    }
}

extension CGSize {
    func square() -> CGSize {
        let sideLenght = min(height, width)
        return .init(width: sideLenght, height: sideLenght)
    }
}
