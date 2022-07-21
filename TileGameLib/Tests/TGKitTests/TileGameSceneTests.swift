import XCTest

@testable import TGKit

final class TileGameSceneTests: XCTestCase {
    func test_scene_setup() {
        let sut = TileGameScene(coordinateConverter: CoordinateConverterDummy())
        XCTAssertEqual(sut.anchorPoint, .zero)
        XCTAssertEqual(sut.scaleMode, .aspectFit)
        XCTAssertEqual(sut.backgroundColor.alphaComponent, 0)
        XCTAssertEqual(sut.size, .zero)
        XCTAssertTrue(sut.children.first is GameNode)
    }
    
    func test_sceneStartsGameWhenItBegins() {
        let spy = GameLoopStubSpy()
        _ = TileGameScene(
            game: spy,
            node: .init(
                gameLoop: spy,
                coordinateConverter: CoordinateConverterDummy()),
            size: .zero
        )
        
        XCTAssertEqual(spy.startCallCount, 1)
    }
    
    
    #if os(OSX)
    
    func test_delegatesClicksOnMacOS() throws {
        throw XCTSkip("TODO")
    }
    
    #else
    func test_delegatesTouchesOnIOS() {
        throw XCTSkip("TODO")
    }
    #endif
}

final class CoordinateConverterDummy: CoordinateConverter {
    var radius: CGFloat = .zero
    func calculateSize() -> CGSize {
        .zero
    }
    func convert(_ point: CGPoint) -> CGPoint {
        .zero
    }
}
