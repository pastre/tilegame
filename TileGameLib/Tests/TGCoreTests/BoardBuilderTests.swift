import XCTest

@testable import TGCore

final class BoardBuilderTest: XCTestCase {
    func test_generates_empty_board() {
        XCTAssertEqual(
            BoardBuilder(size: .zero)
                .board()
                .rows,
            []
        )
    }
    
    func test_generates_board_with_proper_height() {
        // Given
        let expectedHeight = 1
       
        // When
        let actualBoard = BoardBuilder(size: .init(
            width: 0, height: expectedHeight
        ))
            .board()
        
        // Then
        XCTAssertEqual(expectedHeight, actualBoard.rows.count)
    }
    
    func test_generates_board_with_proper_width() {
        // Given
        let expectedWidth = 6
       
        // When
        let actualBoard = BoardBuilder(size: .init(
            width: expectedWidth, height: 1
        ))
            .board()
        
        // Then
        XCTAssertEqual(expectedWidth, actualBoard.rows.first?.count)
    }
    
    func test_fills_board() {
        let board = BoardBuilder(size: 3)
            .fill(withTile: .floor)
            .board()
        
        XCTAssertTrue(
            board.rows
                .allSatisfy { row in
                    row.allSatisfy { tile in
                        tile == .floor
                    }
                },
            "All tiles must be equal to whatever was filled"
        )
    }
    
    func test_generates_exit_border() {
        let board = BoardBuilder(size: 4)
            .fill(withTile: .floor)
            .withExitBorder()
            .board()

        // Then
        XCTAssertEqual(board[0], [.exit, .exit, .exit, .exit], "First row should be exits")
        XCTAssertEqual(board[1], [.exit, .floor, .floor, .exit], "Middle rows should have exits on the ends")
        XCTAssertEqual(board[2], [.exit, .floor, .floor, .exit], "Middle rows should have exits on the ends")
        XCTAssertEqual(board[3], [.exit, .exit, .exit, .exit], "Last row should be exits")
    }
    
    func test_removes_all_tiles() {
        let expectedBoard = Board(rows: [
            [.exit, .exit, .exit, .exit],
            [.exit, .empty, .empty, .exit],
            [.exit, .empty, .empty, .exit],
            [.exit, .exit, .exit, .exit],
        ], size: .zero)
        
        let board = BoardBuilder(size: 4)
            .fill(withTile: .floor)
            .withExitBorder()
            .removing(.floor, percent: 1)
            .board()
        XCTAssertEqual(expectedBoard.rows, board.rows)
    }
    
    func test_removes_no_tiles() {
        let expectedBoard = Board(rows: [
            [.exit, .exit, .exit, .exit],
            [.exit, .floor, .floor, .exit],
            [.exit, .floor, .floor, .exit],
            [.exit, .exit, .exit, .exit],
        ], size: .zero)
        
        let board = BoardBuilder(size: 4)
            .fill(withTile: .floor)
            .withExitBorder()
            .removing(.floor, percent: 0)
            .board()
        XCTAssertEqual(expectedBoard.rows, board.rows)
    }
    
    func test_removes_empty_tiles() {
        let expectedBoard = Board(rows: [
            [.exit, .exit, .exit, .exit],
            [.exit, .floor, .floor, .exit],
            [.exit, .floor, .floor, .exit],
            [.exit, .exit, .exit, .exit],
        ], size: .zero)
        
        let board = BoardBuilder(size: 4)
            .fill(withTile: .empty)
            .withExitBorder()
            .removing(.empty, percent: 1)
            .board()
        XCTAssertEqual(expectedBoard.rows, board.rows)
    }
    
    
    func test_removes_half_tiles() {
        let board = BoardBuilder(size: 4)
            .fill(withTile: .floor)
            .withExitBorder()
            .removing(.floor, percent: 0.5)
            .board()
        XCTAssertEqual(board.count(tile: .empty), board.count(tile: .floor))
    }
    
    func test_board_area_calculation() {
        let board = BoardBuilder(size: 4)
            .fill(withTile: .floor)
            .withExitBorder()
            .removing(.floor, percent: 0.5)
            .board()
        
        XCTAssertEqual(16, board.area)
    }
}

/*
 
 E  E   E   E   E
 
 E  F   F   F   E
 
 E  F   P   F   E
 
 E  F   F   F   E
 
 E  E   E   E   E
 */

extension Board {
    func count(tile: Tile) -> Int {
        rows.reduce(into: 0) {
            $0 += $1.filter { $0 == tile }.count
        }
    }
}
