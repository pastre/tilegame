@testable import TGCore

final class GameLoopSpy: GameLoopDelegate {
    private(set) var gameStateDidChangeCallCount = 0
    private(set) var gameStateDidChangeNewStatePassed: GameState?
    func gameStateDidChange(toNewState gameState: GameState) {
        gameStateDidChangeCallCount += 1
        gameStateDidChangeNewStatePassed = gameState
    }
    
    private(set) var playerDidMoveCallCount = 0
    private(set) var playerDidMovePositionPassed: TilePosition?
    func playerDidMove(toPosition position: TilePosition) {
        playerDidMoveCallCount += 1
        playerDidMovePositionPassed = position
    }
}

extension GameLoop {
    convenience init(levelFactory: @escaping (Int) -> Level) {
        self.init(levelFactory: .init(make: levelFactory),
                  exitFinder: .dummy
        )
    }
}
