import XCTest
import SpriteKit

@testable import TGCore
@testable import TGKit

final class BoardNodeTests: XCTestCase {
    func test_drawsRows() {
        let converter = StubCoordinateConverter()
        converter.convertedValueToUse = .init(x: 2, y: 2)
        let sut = BoardNode(
            coordinateConverter: converter
        )
        
        sut.draw(rows: [
            [.empty, .exit],
            [.floor, .floor]
        ], boardSize: 2)
        
        XCTAssertEqual(sut.children.count, 4)
        XCTAssertEqual(sut.children.first?.position, converter.convertedValueToUse)
    }
    
    func test_addsPlayerToSceneWhenNeeded() {
        let converter = StubCoordinateConverter()
        let sut = BoardNode(
            coordinateConverter: converter
        )
        
        sut.draw(
            playerAtPosition: .zero,
            onBoardWithSize: 2
        )
        
        XCTAssertFalse(sut.children.isEmpty)
    }
    
    func test_drawsPlayerAtRightPosition() {
        let converter = StubCoordinateConverter()
        let sut = BoardNode(
            coordinateConverter: converter
        )
        converter.convertedValueToUse = .init(
            x: 1,
            y: 2
        )
        sut.draw(
            playerAtPosition: .zero,
            onBoardWithSize: 2
        )
        
        XCTAssertEqual(sut.children.first?.position, converter.convertedValueToUse)
    }
    
    func test_returnsNilWhenNoTileIsFoundAtPosition() {
        let converter = StubCoordinateConverter()
        let sut = BoardNode(
            coordinateConverter: converter
        )
        
        let actualTile = sut.tile(atPosition: .zero)
        
        XCTAssertNil(actualTile)
    }
    
    func test_returnsNilWhenOutOfBounds() {
        let converter = StubCoordinateConverter()
        let sut = BoardNode(
            coordinateConverter: converter
        )
        
        sut.draw(rows: [
            [.floor, .floor],
            [.floor, .floor],
        ], boardSize: 2)
        
        let actualTile = sut.tile(atPosition: .init(
            x: -4000,
            y: 4000
        ))
        XCTAssertNil(actualTile)
    }
    
    func test_returnsTileWhenFoundAtPosition() {
        let converter = StubCoordinateConverter()
        let sut = BoardNode(
            coordinateConverter: converter
        )
        sut.draw(rows: [
            [.floor, .floor],
            [.floor, .floor],
        ], boardSize: 2)
        
        let actualTile = sut.tile(atPosition: .zero)
        XCTAssertNotNil(actualTile)
    }
}

final class StubCoordinateConverter: CoordinateConverter {
    var radius: CGFloat = .zero
    var convertedValueToUse: CGPoint = .zero
    var sizeToUse: CGSize = .zero
    
    func convert(_ point: CGPoint) -> CGPoint {
        convertedValueToUse
    }
    
    func calculateSize() -> CGSize {
        sizeToUse
    }
    
}
