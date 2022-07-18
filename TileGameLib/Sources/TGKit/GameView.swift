import SwiftUI
import SpriteKit
import TGCore

public struct GameView: View {
    
    public init() {}
    
    public var body: some View {
        GeometryReader { proxy in
            let converter = HexagonalCoordinateConverter(
                screenSize: proxy.size,
                boardSize: .init(integerLiteral: LevelMaker.defaultBoardSize)
            )
            SpriteView(
                scene: TileGameScene(
                    coordinateConverter: converter
                ),
                options: [.allowsTransparency,
                          .shouldCullNonVisibleNodes,
                          .ignoresSiblingOrder
                ]
            )
            .position(x: proxy.frame(in: .local).midX, y: proxy.frame(in: .local).midY)
            .frame(width: converter.calculateSize().width, height: converter.calculateSize().height)
        }
        .aspectRatio(contentMode: .fit)
    }
}
