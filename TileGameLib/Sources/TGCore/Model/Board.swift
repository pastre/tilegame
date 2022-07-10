public struct Board: Equatable {
    public private(set) var rows: [[Tile]]
    public let size: BoardSize
    
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
        get { rows[tilePostion.y][tilePostion.x] }
        set { rows[tilePostion.y][tilePostion.x] = newValue }
    }
}

extension Board {
    func contains(position: TilePosition) -> Bool {
        guard let row = rows[safe: position.y]
        else { return false }
        return row.indices.contains(position.x)
    }
}
