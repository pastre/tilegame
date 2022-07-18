public struct Board: Equatable {
    public private(set) var rows: [[Tile]]
    public let size: BoardSize
    
    public init(rows: [[Tile]], size: BoardSize) {
        self.rows = rows
        self.size = size
    }
    
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

public extension Array where Element == [Tile] {
    func iterate(_ block: (TilePosition, Tile) -> Void) {
        for (j, rows) in enumerated() {
            for (i, tile) in rows.enumerated() {
                block(.init(x: i, y: j), tile)
            }
        }
    }
    
    func map<T>(_ block: (TilePosition, Tile) -> T) -> [[T]] {
        enumerated().map { j, rows in
            rows.enumerated().map { i, tile in
                block(.init(x: i, y: j), tile)
            }
        }
    }
}

public extension Collection where Element: Collection {
    func linearMap<T>(_ block: (Self.Element.Element) -> T) -> [[T]] {
        enumerated().map { j, rows in
            rows.enumerated().map { i, tile in
                block(tile)
            }
        }
    }
    
    func linearForEach(_ block: (Self.Element.Element) -> Void) -> Void {
        forEach { rows in
            rows.forEach { element in
                block(element)
            }
        }
    }
}
