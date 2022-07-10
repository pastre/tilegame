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
