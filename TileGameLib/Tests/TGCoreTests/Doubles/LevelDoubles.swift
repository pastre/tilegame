@testable import TGCore

struct DummyLevel: Level {}

final class LevelSpy: Level {
    private(set) var removeTileCallCount = 0
    func removeTile(atPosition position: TilePosition) {
        removeTileCallCount += 1
    }
    
    private(set) var movePlayerCallCount = 0
    private(set) var movePlayerPositionPassed: TilePosition?
    func movePlayer(toPosition position: TilePosition) {
        movePlayerCallCount += 1
        movePlayerPositionPassed = position
    }
}

final class LevelStub: Level {
    var boardToUse: Board?
    
    var board: Board {
        boardToUse ?? .empty
    }
    var isGameOverToUse: Bool = true
    func isGameOver() -> Bool {
        isGameOverToUse
    }
    
    private(set) var movePlayerPositionPassed: TilePosition?
    func movePlayer(toPosition position: TilePosition) {
        movePlayerPositionPassed = position
    }
}

extension Level {
    var board: Board { .empty }
    var playerPosition: TilePosition? { nil }
    
    func isGameOver() -> Bool { true }
    func movePlayer(toPosition position: TilePosition) {}
    func removeTile(atPosition position: TilePosition) {}
}

