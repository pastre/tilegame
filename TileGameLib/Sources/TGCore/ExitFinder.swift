struct ExitFinder {
    let find: (Level) -> TilePosition?
}

extension ExitFinder {
    static let usingAStar: Self = .init { level in
        let board = level.board
        let exits = board.rows
            .enumerated()
            .flatMap { (j, row) in
                row.enumerated()
                    .filter { _, tile in tile == .exit }
                    .map { i, _ in TilePosition(x: i, y: j) }
            }
        
        let aStar = AStar<Board>.init(
            graph: level.board,
            heuristic: {
                Double(
                    abs($0.x - $1.x) +
                    abs($0.y - $1.y)
                )
            }
        )
        
        return exits
            .map {
                aStar.path(
                    start: $0,
                    target: level.playerPosition!
                )
            }
            .min(
                by: { $0.count < $1.count }
            )?
            .dropLast()
            .last
    }
}
