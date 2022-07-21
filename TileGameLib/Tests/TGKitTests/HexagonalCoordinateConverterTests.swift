import XCTest

@testable import TGCore
@testable import TGKit

final class HexagonalCoordinateConverterTests: XCTestCase {
    private let sut = HexagonalCoordinateConverter(
        screenSize: 10,
        boardSize: 2
    )
        
    func test_calculatesRadius() {
        XCTAssertEqual(
            sut.radius,
            2.3,
            accuracy: 0.01
        )
    }
        
    func test_calculatesSize() {
        let actualSize = sut.calculateSize()
        XCTAssertEqual(
            actualSize.width,
            10
        )
        
        XCTAssertEqual(
            actualSize.height,
            8.08,
            accuracy: 0.01
        )
    }
    
    func test_convertsSimplePosition() {
        let actualPosition = sut.convert(.zero)
        XCTAssertEqual(
            actualPosition.x,
            2
        )
        XCTAssertEqual(
            actualPosition.y,
            2.3,
            accuracy: 0.01
        )
    }
    
    func test_addsOffsetToOddPosition() {
        let actualPosition = sut.convert(
            CGPoint(x: 1, y: 1)
        )
        XCTAssertEqual(
            actualPosition.x,
            8
        )
        XCTAssertEqual(
            actualPosition.y,
            5.77,
            accuracy: 0.01
        )
    }
}

extension CGSize: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(width: value, height: value)
    }
}
