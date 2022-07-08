import XCTest

@testable import TGCore

final class LevelManagerTests: XCTestCase {
    
    private var dummyBoard: Board {
        BoardBuilder(size: 4)
            .fill(withTile: .floor)
            .board()
    }
    
    private var largeGame: LevelManager {
        LevelManager(board: Board(rows: [
                    [.exit,  .floor, .floor, .floor, .exit],
                    [.floor, .floor, .floor, .floor, .floor],
                    [.floor, .floor, .floor, .floor, .floor],
                    [.floor, .floor, .floor, .floor, .floor],
                    [.floor, .floor, .floor, .floor, .floor],
                    [.exit,  .floor, .floor, .floor, .exit],
                ], size: 5)
        )
    }
    
    func test_tile_removed_sets_tile_to_empty() {
        let game = LevelManager(board: dummyBoard)
        
        game.removeTile(atPosition: .zero)
        
        XCTAssertEqual(game.board.rows.first?.first, .empty)
    }
    
    func test_player_moves_to_position() {
        let game = LevelManager(board: dummyBoard)
        
        game.movePlayer(toPosition: .zero)
        
        XCTAssertEqual(game.playerPosition, .zero)
    }
    
    func test_player_wont_move_to_empty_position() {
        let game = LevelManager(board: .init(rows: [[.empty]], size: .zero))
        game.movePlayer(toPosition: .zero)
        XCTAssertNil(game.playerPosition)
    }
    
    func test_game_not_over_when_away_from_exits() {
        let game = largeGame
        
        game.movePlayer(toPosition: .init(x: 2, y: 2))
        
        XCTAssertFalse(game.isGameOver())
    }
    
    func test_game_over_when_over_exit() {
        let game = largeGame
        
        game.movePlayer(toPosition: .zero)
        XCTAssertTrue(game.isGameOver())
    }
    
    func test_game_over_when_exit_is_northwest() {
        let game = largeGame
        
        game.movePlayer(toPosition: .init(x: 1, y: 1))
        XCTAssertTrue(game.isGameOver())
    }
    
    func test_game_over_when_exit_is_northeast() {
        let game = largeGame
        
        game.movePlayer(toPosition: .init(x: 4, y: 1))
        XCTAssertTrue(game.isGameOver())
    }
    
    func test_game_over_when_exit_is_southeast() {
        let game = largeGame
        
        game.movePlayer(toPosition: .init(x: 4, y: 4))
        XCTAssertTrue(game.isGameOver())
    }
    
    func test_game_over_when_exit_is_southwest() {
        let game = largeGame
        
        game.movePlayer(toPosition: .init(x: 1, y: 4))
        XCTAssertTrue(game.isGameOver())
    }
}
