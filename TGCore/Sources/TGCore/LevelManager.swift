protocol Level {
    var board: Board { get }
    var playerPosition: TilePosition? { get }
    
    func movePlayer(toPosition position: TilePosition)
    func removeTile(atPosition position: TilePosition)
    func isGameOver() -> Bool
}

final class LevelManager: Level {
    private(set) var board: Board
    private(set) var playerPosition: TilePosition?
    
    init(board: Board) {
        self.board = board
    }

    func removeTile(atPosition position: TilePosition) {
        board[position] = .empty
    }
    
    func movePlayer(toPosition position: TilePosition) {
        guard board.contains(position: position),
              board[position] != .empty
        else { return }
        playerPosition = position
    }
    
    func isGameOver() -> Bool {
        getPlayerSurroundings()
            .map { board[$0] }
            .contains(.exit)
    }
    
    private func getPlayerSurroundings() -> [TilePosition] {
        guard let playerPosition = playerPosition
        else { return [] }

        return [playerPosition] + playerPosition.surroundings
            .filter(board.contains)
    }
}
