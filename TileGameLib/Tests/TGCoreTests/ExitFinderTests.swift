import XCTest

@testable import TGCore

final class ExitFinderTEsts: XCTestCase {
    func test_returnsNilWhenLevelHasNotStarted() {
        let level = LevelManager(board: .init(rows: []))
        XCTAssertNil(ExitFinder.usingAStar.find(level))
    }
    
    func test_returnsNilWhenThereIsNoExit() {
        let level = LevelManager(
            board: BoardBuilder(size: 4)
                .fill(withTile: .floor)
                .board()
        )
        
        level.movePlayer(toPosition: .zero)
        
        let path = ExitFinder.usingAStar.find(level)
        
        XCTAssertNil(path)
    }
    
    func test_returnsNilWhenNoPath() {
        let level = LevelManager(
            board: .init(rows: [
                [.exit, .empty, .floor],
                [.empty, .empty, .floor],
                [.floor, .floor, .floor],
            ])
        )
        level.movePlayer(toPosition: .init(x: 2, y: 2))
        let path = ExitFinder.usingAStar.find(level)
        
        XCTAssertNil(path)
    }
    
    func test_returnsShortestPathWhenSinglePath() {
        let level = LevelManager(
            board: .init(rows: [
                [.exit, .floor, .floor,],
                [.floor, .floor, .floor,],
                [.floor, .floor, .floor,],
            ])
        )
        
        level.movePlayer(toPosition: .init(x: 2, y: 2))
        let path = ExitFinder.usingAStar.find(level)
        
        XCTAssertEqual(TilePosition(x: 1, y: 2), path)
    }
    
    func test_returnsShortestPathWhenMultiplePathsAreFound() {
        let level = LevelManager(
            board: .init(rows: [
                [.exit, .floor, .floor, .floor],
                [.floor, .floor, .floor, .floor],
                [.floor, .floor, .floor, .floor],
                [.floor, .floor, .floor, .exit],
            ])
        )
        
        level.movePlayer(toPosition: .init(x: 2, y: 2))
        let path = ExitFinder.usingAStar.find(level)
        
        XCTAssertEqual(TilePosition(x: 3, y: 2), path)
    }
}

extension ExitFinder {
    static let dummy: Self = .init(find: { _ in .zero })
}
