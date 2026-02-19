import UIKit
import XCTest
@testable import ProductSearch

@MainActor
class HomeFactoryTest: XCTestCase {
    // MARK: - Tests: Factory initialization

    func testInitializeModule_returnsViewController() {
        let viewController = HomeFactory.initialize()
        XCTAssertNotNil(viewController)
    }

    func testInitializeModule_returnCorrectType() {
        let viewController = HomeFactory.initialize()
        XCTAssertTrue(viewController is HomeViewController)
    }

    func testInitializeModule_presenterIsSet() {
        let viewController = HomeFactory.initialize()
        XCTAssertNotNil(viewController.presenter)
    }

    func testInitializeModule_callingTwiceReturnsDifferentInstances() {
        let first = HomeFactory.initialize()
        let second = HomeFactory.initialize()
        XCTAssertFalse(first === second)
    }
}
