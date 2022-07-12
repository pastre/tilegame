import SwiftUI
import SpriteKit

import TGCore
import TGKit

@main
struct TileGameApp: App {
    let node = GameNode()
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
            SpriteView(scene: {
                let scene = SKScene(size: proxy.size.square())
//                scene.anchorPoint = .init(x: 0.5, y: 0.5)
                scene.scaleMode = .aspectFit
                scene.backgroundColor = .white
                scene.addChild(node)
                return scene
            }())
            .onAppear() {
                let game = GameLoop()
                node.render(level: game.level!)
            }
        }
    }
}

extension CGSize {
    func square() -> CGSize {
        let sideLenght = min(height, width)
        return .init(width: sideLenght, height: sideLenght)
    }
}
