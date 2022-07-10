import XCTest

@testable import TGCore

final class ExitFinderTEsts: XCTestCase {
    func test_returnsNilWhenLevelHasNotStarted() {
        let level = LevelManager(board: .init(rows: []))
        XCTAssertNil(ExitFinder.usingDjikstra.find(level))
    }
}
