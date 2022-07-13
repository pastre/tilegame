import CoreGraphics
public struct TilePosition: Equatable, Hashable {
    let x, y: Int
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
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
        y.isMultiple(of: 2) ? [
            offset(x: -1, y: -1),
            offset(x: -1),
            offset(x: -1, y: 1),
            offset(y: -1),
            offset(y: 1),
            offset(x: 1),
        ] : [
            offset(x: -1),
            offset(y: -1),
            offset(y: 1),
            offset(x: 1, y: -1),
            offset(x: 1),
            offset(x: 1, y: 1),
        ]
    }
}

extension TilePosition: CustomDebugStringConvertible {
    public var debugDescription: String {
        "(\(x), \(y))"
    }
}

extension TilePosition {
    public var cgPoint: CGPoint { .init(x: x, y: y) }
}
