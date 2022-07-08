struct Board: Equatable {
    var rows: [[Tile]]
    let size: BoardSize
    
    var area: Int { size.area }
    var height: Int { size.height }
    var width: Int { size.width }
}

extension Board: CustomDebugStringConvertible {
    public var debugDescription: String {
        rows.map { row in
            row.map { tile in
                switch tile {
                case .empty:
                    return "E"
                case .exit:
                    return "O"
                case .floor:
                    return "F"
                }
            }
            .joined(separator: "\t")
        }.joined(separator: "\n")
    }
}

extension Board {
    static var empty: Self {
        .init(rows: [], size: .zero)
    }
}

extension Board {
    subscript(_ index: Int) -> [Tile] { rows[index] }
    
    subscript(safe index: Int) -> [Tile]? { rows[safe: index] }
    
    subscript(_ tilePostion: TilePosition) -> Tile {
        get { rows[tilePostion.x][tilePostion.y] }
        set { rows[tilePostion.x][tilePostion.y] = newValue }
    }
}
