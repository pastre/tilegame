import XCTest

@testable import TGCore

final class GameLoopTests: XCTestCase {
    func test_start_begins_with_level_zero_and_sets_current_level() throws {
        let sut = GameLoop(levelFactory: {
            XCTAssertEqual(0, $0)
            return DummyLevel()
        })
        
        sut.start()
        let actualLevel = try XCTUnwrap(sut.level)
        XCTAssertTrue(actualLevel is DummyLevel)
    }
    
    func test_removeTile_itShouldRemoveTileFromLevel() {
        let spy = LevelSpy()
        let sut = GameLoop(levelFactory: { _ in spy })
        sut.start()
        
        sut.removeTile(atPosition: .zero)
        
        XCTAssertEqual(1, spy.removeTileCallCount)
    }
    
    func test_whenDelegateIsSetItShouldGetNewestGameState() {
        let spy = GameLoopSpy()
        let stub = LevelStub()
        stub.isGameOverToUse = true
        
        let game = GameLoop(levelFactory: { _ in stub })
        game.delegate = spy
        
        XCTAssertEqual(1, spy.gameStateDidChangeCallCount)
        XCTAssertEqual(spy.gameStateDidChangeNewStatePassed, .notStarted)
    }
    
    func test_whenTileIsRemovedAndNoLevelIsLoadedItShouldDoNothing() {
        let spy = GameLoopSpy()
        let stub = LevelStub()
        stub.isGameOverToUse = true
        
        let game = GameLoop(levelFactory: { _ in stub })
        game.delegate = spy
        
        XCTAssertEqual(1, spy.gameStateDidChangeCallCount)
        XCTAssertEqual(spy.gameStateDidChangeNewStatePassed, .notStarted)
    }
    
    func test_whenGameStartsItShouldUpdateGameState() {
        let spy = GameLoopSpy()
        let stub = LevelStub()
        stub.isGameOverToUse = true
        
        let game = GameLoop(levelFactory: { _ in stub })
        game.delegate = spy
        
        game.start()
        
        XCTAssertEqual(2, spy.gameStateDidChangeCallCount)
        XCTAssertEqual(spy.gameStateDidChangeNewStatePassed, .running)
    }

    
    func test_whenTileIsRemovedAndGameIsOverItShouldSetGameStateToOver() {
        let spy = GameLoopSpy()
        let stub = LevelStub()
        stub.isGameOverToUse = true
        
        let game = GameLoop(levelFactory: { _ in stub })
        game.delegate = spy
        game.start()
        
        game.removeTile(atPosition: .zero)
        
        XCTAssertEqual(3, spy.gameStateDidChangeCallCount)
        XCTAssertEqual(spy.gameStateDidChangeNewStatePassed, .over)
        XCTAssertEqual(0, spy.playerDidMoveCallCount)
    }
    
    func test_whenTileIsRemovedAndGameIsNotOverItShouldMovePlayer() throws {
        let expectedPosition = TilePosition(x: 0, y: 1)
        let spy = GameLoopSpy()
        let stub = LevelStub()
        stub.boardToUse = BoardBuilder(size: 3)
            .fill(withTile: .floor)
            .board()
        let game = GameLoop(
            levelFactory: .stub(stub),
            exitFinder: .stub(expectedPosition)
        )
        
        stub.isGameOverToUse = false
        game.delegate = spy
        
        game.start()
        
        game.removeTile(atPosition: .zero)
        
        XCTAssertEqual(2, spy.gameStateDidChangeCallCount)
        XCTAssertEqual(spy.gameStateDidChangeNewStatePassed, .running)
        XCTAssertEqual(expectedPosition, stub.movePlayerPositionPassed)
        XCTAssertEqual(1, spy.playerDidMoveCallCount)
        XCTAssertEqual(expectedPosition, spy.playerDidMovePositionPassed)
    }
    
    func test_passesLevelWhenPlayerHasNoMoves() {
        let spy = GameLoopSpy()
        let stub = LevelStub()
        stub.boardToUse = BoardBuilder(size: 3)
            .fill(withTile: .floor)
            .board()
        let game = GameLoop(
            levelFactory: .stub(stub),
            exitFinder: .stub(nil)
        )
        
        stub.isGameOverToUse = false
        game.delegate = spy
        
        game.start()
        game.removeTile(atPosition: .zero)
        
        XCTAssertEqual(3, spy.gameStateDidChangeCallCount)
        XCTAssertEqual(spy.gameStateDidChangeNewStatePassed, .won)
        XCTAssertEqual(1, game.levelsPassed)
    }
}

extension ExitFinder {
    static func stub(_ expectedValue: TilePosition?) -> Self {
        .init(find: { _ in expectedValue })
    }
}

extension LevelMaker {
    static func stub(_ expectedValue: Level) -> Self {
        .init(make: { _ in expectedValue })
    }
    
    static var dummy: Self = .init { _ in
        DummyLevel()
    }
}
