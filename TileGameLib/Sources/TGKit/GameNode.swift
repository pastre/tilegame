import SpriteKit
import TGCore

protocol GameUIDelegate {
    func showStartScreen()
    func showGame()
    func showGameOverScreen()
}

public final class GameNode: SKNode {
    private let boardNode: BoardNode
    private let gameLoop: GameLoop

    public init(
        gameLoop: GameLoop,
        coordinateConverter: CoordinateConverter
    ) {
        self.gameLoop = gameLoop
        self.boardNode = .init(coordinateConverter: coordinateConverter)
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
        guard let tilePosition = boardNode.tile(
                atPosition: position,
                boardSize: gameLoop.level.board.size
              )
        else { return }
        gameLoop.removeTile(atPosition: tilePosition)
    }
    
    public func render(level: Level?) {
        guard let level = level
        else { return }

        boardNode.draw(
            rows: level.board.rows,
            boardSize: level.board.size
        )

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
            gameLoop.start()
        case .won:
            gameLoop.createNewLevel()
        }
    }
    
    public func playerDidMove(_ level: Level, toPosition position: TilePosition) {
        render(level: gameLoop.level)
    }
}
