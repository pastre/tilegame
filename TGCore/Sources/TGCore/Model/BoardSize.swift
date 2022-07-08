struct BoardSize: ExpressibleByIntegerLiteral, Equatable {
    let width: Int
    let height: Int
    
    var area: Int { width * height }
    
    init(integerLiteral value: IntegerLiteralType) {
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
