public protocol Level {
    var board: Board { get }
    var playerPosition: TilePosition? { get }
    
    func movePlayer(toPosition position: TilePosition)
    func removeTile(atPosition position: TilePosition)
    func isGameOver() -> Bool
}


public extension Level {
    static func `default`(board: Board) -> Level {
        LevelManager(board: board)
    }
}

final class LevelManager: Level {
    private(set) var board: Board
    private(set) var playerPosition: TilePosition?
    
    init(board: Board) {
        self.board = board
    }

    func removeTile(atPosition position: TilePosition) {
        guard playerPosition != position
        else { return }
        board[position] = .empty
    }
    
    func movePlayer(toPosition position: TilePosition) {
        guard board.contains(position: position),
              board[position] != .empty
        else { return }
        playerPosition = position
    }
    
    func isGameOver() -> Bool {
        if let playerPosition = playerPosition, board[playerPosition] == .exit {
            return true
        }
        let surroundings = getPlayerSurroundings().map { board[$0] }.filter { $0 == .exit }
        return surroundings.count > 1
    }
    
    private func getPlayerSurroundings() -> [TilePosition] {
        guard let playerPosition = playerPosition
        else { return [] }

        let s = [playerPosition] + playerPosition.surroundings
            .filter(board.contains)
        debugPrint(s)
        return s
    }
}
