public struct LevelMaker {
    let make: (Int) -> Level
    
    public init(make: @escaping (Int) -> Level) {
        self.make = make
    }
}

extension LevelMaker {
    
    public static let defaultBoardSize = 8
    
    static let `default`: Self = .init { level in
        let board = BoardBuilder(size: .init(integerLiteral: defaultBoardSize))
            .fill(withTile: .floor)
            .withExitBorder()
            .removing(.exit, percent: 0.4)
            .removing(.floor, percent: 0.2)
            .board()
        return LevelManager(board: board)
    }
}

#if DEBUG
public extension LevelMaker {
    static func debug(board: Board) -> Self {
        .init { _ in
            LevelManager(board: board)
        }
    }
}
#endif
