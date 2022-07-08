protocol Level {
    var board: Board { get }
    var playerPosition: TilePosition? { get }
    
    func movePlayer(toPosition position: TilePosition)
    func removeTile(atPosition position: TilePosition)
    func isGameOver() -> Bool
}


final class LevelManager {
    private(set) var board: Board
    private(set) var playerPosition: TilePosition?
    
    init(board: Board) {
        self.board = board
    }

    func removeTile(atPosition position: TilePosition) {
        board[position] = .empty
    }
    
    func movePlayer(toPosition position: TilePosition) {
        guard board[position] != .empty
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

        return [
            playerPosition,
            playerPosition.offset(x: -1), // W
            playerPosition.offset(x: 1),  // E
            playerPosition.offset(y: -1), // N
            playerPosition.offset(y: 1), // S
            playerPosition.offset(x: -1, y: -1), // NW
            playerPosition.offset(x: 1, y: -1), // NE
            playerPosition.offset(x: -1, y: 1), // SW
            playerPosition.offset(x: 1, y: 1), // SE
        ]
        .filter(contains)
    }
    private func contains(position: TilePosition) -> Bool {
        guard let row = board[safe: position.x]
        else { return false }
        return row.indices.contains(position.y)
    }
}
