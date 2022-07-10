struct ExitFinder {
    let find: (Level) -> TilePosition?
}

extension ExitFinder {
    static let usingDjikstra: Self = .init { level in
        guard let playerPosition = level.playerPosition
        else { return nil }
        let solver = Djikstra(board: level.board,
                              playerPosition: playerPosition
        ) // TODO force unwrap
        return solver.findPathsToExits()?.first
    }
}
