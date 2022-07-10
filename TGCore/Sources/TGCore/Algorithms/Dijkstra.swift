final class Djikstra {
    typealias Path = [TilePosition]
    
    private let playerPosition: TilePosition
    private let board: Board
    private let exits: [TilePosition]
    
    init(board: Board, playerPosition: TilePosition) {
        self.playerPosition = playerPosition
        self.board = board
        self.exits = board.rows
            .enumerated()
            .flatMap { (j, row) in
                row.enumerated()
                    .filter { _, tile in tile == .exit }
                    .map { i, _ in .init(x: i, y: j) }
            }
    }
    
    func findPathsToExits() -> Path? {
        exits
            .compactMap(pathToPlayer)
            .min(by: { $0.count < $1.count })
    }
    
    private func pathToPlayer(fromExitPosition position: TilePosition) -> Path? {
        var frontier = PriorityQueue<TilePosition>()
        var cameFrom: [TilePosition : TilePosition?] = [position : nil]
        var costSoFar = [position : 0]
        
        frontier.enqueue(position, priority: 0)
        
        while let current = frontier.dequeue() {
            if current == playerPosition {
                var path: Path = []
                var backwards = current
                while let i: TilePosition = cameFrom[backwards]! {
                    path.append(i)
                    backwards = i
                }
                return path
            }
            
            for next in current.surroundings where board.contains(position: next) && board[next] != .empty {
                let newCoast = costSoFar[current] ?? 0 + 1
                if !costSoFar.keys.contains(next) || newCoast < (costSoFar[next] ?? .max) {
                    costSoFar[next] = newCoast
                    frontier.enqueue(next, priority: newCoast)
                    cameFrom[next] = current
                }
            }
        }
        return nil
    }
}

