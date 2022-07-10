import XCTest

@testable import TGCore

final class PathFinderTests: XCTestCase {
    func test_horizontal_path() {
        let board = Board(
            rows: [[.exit, .floor, .floor, .floor, .floor, .exit]]
        )
        let level = LevelManager(board: board)
        level.movePlayer(toPosition: .zero.offset(x: 2))
        
        let actualPosition = ExitFinder.usingDjikstra.find(level)
        
        XCTAssertEqual(actualPosition, .zero.offset(x: 1))
    }
    
    func test_vertical_path() {
        let board = Board(
            rows: [
                [.exit,],
                [.floor,],
                [.floor,],
                [.floor,],
                [.floor,],
                [.exit,],
            ]
        )
        let level = LevelManager(board: board)
        level.movePlayer(toPosition: .zero.offset(y: 3))
        
        let actualPosition = ExitFinder.usingDjikstra.find(level)
        
        XCTAssertEqual(actualPosition, .zero.offset(y: 4))
    }
    
    func test_vertical_with_empty() {
        let board = Board(
            rows: [
                [.exit,],
                [.floor,],
                [.floor,],
                [.floor,],
                [.empty,],
                [.exit,],
            ]
        )
        let level = LevelManager(board: board)
        level.movePlayer(toPosition: .zero.offset(y: 3))
        
        let actualPosition = ExitFinder.usingDjikstra.find(level)
        
        XCTAssertEqual(actualPosition, .zero.offset(y: 2))
    }
    
    func test_horizontal_with_empty() {
        let board = Board(
            rows: [[.exit, .floor, .floor, .floor, .empty, .exit]]
        )
        let level = LevelManager(board: board)
        level.movePlayer(toPosition: .zero.offset(x: 3))
        
        let actualPosition = ExitFinder.usingDjikstra.find(level)
        
        XCTAssertEqual(actualPosition, .zero.offset(x: 2))
    }
}
