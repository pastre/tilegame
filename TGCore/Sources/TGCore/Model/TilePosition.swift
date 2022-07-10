public struct TilePosition: Equatable, Hashable {
    let x, y: Int
}

extension TilePosition {
    static var zero: Self { .init(x: 0, y: 0) }
}

extension TilePosition {
    func offset(x: Int = 0, y: Int = 0) -> TilePosition {
        .init(
            x: self.x + x,
            y: self.y + y
        )
    }
}

extension TilePosition {
    var surroundings: [TilePosition] {
        [
            offset(x: -1), // W
            offset(x: 1),  // E
            offset(y: -1), // N
            offset(y: 1), // S
            offset(x: -1, y: -1), // NW
            offset(x: 1, y: -1), // NE
            offset(x: -1, y: 1), // SW
            offset(x: 1, y: 1), // SE
        ]
    }
}

extension TilePosition: CustomDebugStringConvertible {
    public var debugDescription: String {
        "(\(x), \(y))"
    }
}
