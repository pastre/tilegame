import XCTest

@testable import TGCore
@testable import TGKit

final class GameNodeTests: XCTestCase {
    func test_setsDelegateWhenCreated() {
        let stubSpy = GameLoopStubSpy()
        let sut = GameNode(
            gameLoop: stubSpy,
            coordinateConverter: StubCoordinateConverter()
        )
        
        XCTAssertIdentical(stubSpy.delegate, sut)
    }
    
    func test_startsGameLoop() {
        let stubSpy = GameLoopStubSpy()
        let sut = GameNode(
            gameLoop: stubSpy,
            coordinateConverter: StubCoordinateConverter()
        )
        
        sut.start()
        
        XCTAssertEqual(1, stubSpy.startCallCount)
    }
    
    func test_doesNothingWhenTouchIsNotOnATile() {
        let stubSpy = GameLoopStubSpy()
        let sut = GameNode(
            gameLoop: stubSpy,
            coordinateConverter: StubCoordinateConverter()
        )
        
        sut.onTouch(atPosition: .zero)
        
        XCTAssertEqual(0, stubSpy.removeTileCallCount)
    }
    
    func test_removesTileWhenTouchIsOnATile() {
        let stubSpy = GameLoopStubSpy()
        let sut = GameNode(
            gameLoop: stubSpy,
            coordinateConverter: StubCoordinateConverter()
        )
        let level = LevelStub()
        level.boardToUse = BoardBuilder(size: 2)
            .fill(withTile: .floor)
            .board()
        stubSpy.level = level
        
        sut.render(level: stubSpy.level)
        sut.onTouch(atPosition: .zero)
        
        XCTAssertEqual(1, stubSpy.removeTileCallCount)
    }
    
    func test_rendersWhenGameStateChanges() {
        let stubSpy = GameLoopStubSpy()
        let sut = GameNode(
            gameLoop: stubSpy,
            coordinateConverter: StubCoordinateConverter()
        )
        let level = LevelStub()
        level.boardToUse = BoardBuilder(size: 4)
            .fill(withTile: .floor)
            .board()
        stubSpy.level = level
        
        sut.render(level: stubSpy.level)
        sut.onTouch(atPosition: .zero)
        
        XCTAssertEqual(1, stubSpy.removeTileCallCount)
    }
    
    func test_drawsPlayerWhenItHasAPosition() {
        let stubSpy = GameLoopStubSpy()
        let sut = GameNode(
            gameLoop: stubSpy,
            coordinateConverter: StubCoordinateConverter()
        )
        let level = LevelStub()
        level.boardToUse = BoardBuilder(size: 2)
            .fill(withTile: .floor)
            .board()
        level.playerPosition = .zero
        stubSpy.level = level
        
        sut.render(level: stubSpy.level)
        sut.onTouch(atPosition: .zero)
        
        XCTAssertEqual(level.board.area + 1, sut.children.first?.children.count)
    }
}

final class GameLoopStubSpy: GameLoopProtocol {
    var level: Level = LevelStub()
    
    var delegate: GameLoopDelegate?
    
    private(set) var startCallCount = 0
    func start() {
        startCallCount += 1
    }
    
    private(set) var removeTileCallCount = 0
    func removeTile(atPosition: TilePosition) {
        removeTileCallCount += 1
    }
}

final class LevelStub: Level {
    var playerPosition: TilePosition?
    
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
    
    private(set) var removeTileCallCount = 0
    func removeTile(atPosition position: TilePosition) {
        removeTileCallCount += 1
    }
}
