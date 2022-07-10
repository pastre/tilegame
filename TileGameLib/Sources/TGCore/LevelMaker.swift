struct LevelMaker {
    let make: (Int) -> Level
}

extension LevelMaker {
    static let `default`: Self = .init { level in
        let board = BoardBuilder(size: 8)
            .fill(withTile: .floor)
            .withExitBorder()
            .removing(.exit, percent: 0.4)
            .removing(.floor, percent: 0.2)
            .board()
        return LevelManager(board: board)
    }
}
