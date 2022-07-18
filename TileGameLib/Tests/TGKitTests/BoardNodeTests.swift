import XCTest
import SpriteKit

@testable import TGCore
@testable import TGKit

final class BoardNodeTests: XCTestCase {
    func test_drawingPlayerAddsItToTheScene() {
        let node = BoardNode()
        
        node.draw(
            playerAtPosition: .zero,
            onBoardWithSize: 1
        )
        
        node.draw(
            playerAtPosition: .zero,
            onBoardWithSize: 1
        )
        
        XCTAssertNotNil(node.childNode(withName: "PlayerNode"))
    }
    
    func test_convertsPlayerPositionToHexagonalCoordinates()  throws {
        let node = BoardNode()
        let scene = SKScene(size: .init(
            width: 1000, height: 1000
        ))
        scene.addChild(node)
        node.draw(
            playerAtPosition: .zero,
            onBoardWithSize: 1
        )
        let playerNode = try XCTUnwrap(node.childNode(withName: "PlayerNode"))
        XCTAssertEqual(playerNode.position.y, 500)
    }
    
    func test_drawRows() throws {
        let node = BoardNode()
        let scene = SKScene(size: .init(
            width: 1000, height: 1000
        ))
        scene.addChild(node)
        
        node.draw(rows: [
            [.floor, .exit],
            [.exit, .empty]
        ], boardSize: 2)
        
        XCTAssertNotNil(
            node.childNode(withName: "Floor")
        )
        XCTAssertNotNil(
            node.childNode(withName: "Empty")
        )
        XCTAssertNotNil(
            node.childNode(withName: "Exit")
        )
    }
    
    func test_retursTileAtScreenPosition() throws {
        let node = BoardNode()
        let scene = SKScene(size: .init(
            width: 1000, height: 1000
        ))
        scene.addChild(node)
        
        node.draw(rows: [
            [.floor, .exit],
            [.exit, .empty]
        ], boardSize: 2)
        let aNodePosition = try XCTUnwrap(node.children.first?.position)
        let actualPosition = node.tile(atPosition: aNodePosition, boardSize: 2)
        XCTAssertEqual(.zero, actualPosition)
    }
    
    func test_retursNilWhenTileNotFound() {
        let node = BoardNode()
        node.draw(rows: [
            [.floor, .exit],
            [.exit, .empty]
        ], boardSize: 2)
        
        let actualPosition = node.tile(atPosition: .init(x: 1, y: 1), boardSize: 2)
        XCTAssertNil(actualPosition)
    }
}
