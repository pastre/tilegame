public struct BoardSize: ExpressibleByIntegerLiteral, Equatable {
    public let width: Int
    public let height: Int
    
    var area: Int { width * height }
    
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(width: value, height: value)
    }
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
}

extension BoardSize {
    static var zero: Self { .init(width: 0, height: 0) }
}

public extension BoardSize {
    func iterate(_ block: (TilePosition) -> Void) {
        for j in 0..<height {
            for i in 0..<width {
                block(.init(x: i, y: j))
            }
        }
    }
    
    func iterate(_ block: (Int, Int) -> Void) {
        for j in 0..<height {
            for i in 0..<width {
                block(i, j)
            }
        }
    }
}
