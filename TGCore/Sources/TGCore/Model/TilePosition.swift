struct TilePosition: Equatable {
    let x, y: Int
}

extension TilePosition {
    static var zero: Self { .init(x: 0, y: 0) }
}

extension TilePosition {
    func offset(x: Int = 0, y: Int = 0) -> TilePosition {
        .init(
            x: self.x -  x,
            y: self.y - y
        )
    }
}
