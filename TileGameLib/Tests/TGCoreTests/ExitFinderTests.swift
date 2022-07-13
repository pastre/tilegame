import XCTest

@testable import TGCore

final class ExitFinderTEsts: XCTestCase {
    func test_returnsNilWhenLevelHasNotStarted() {
        let level = LevelManager(board: .init(rows: []))
        XCTAssertNil(ExitFinder.usingAStar.find(level))
    }
}

extension ExitFinder {
    static let dummy: Self = .init(find: { _ in .zero })
}
