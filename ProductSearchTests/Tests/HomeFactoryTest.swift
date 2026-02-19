import UIKit
import XCTest
@testable import ProductSearch

@MainActor
class HomeFactoryTest: XCTestCase {
    // MARK: - Tests: Factory initialization

    func testInitializeModuleReturnsViewController() {
        // when
        let viewController = HomeFactory.initialize()

        // then
        XCTAssertNotNil(viewController)
    }

    func testInitializeModuleReturnsCorrectType() {
        // when
        let viewController = HomeFactory.initialize()

        // then
        XCTAssertTrue(viewController is HomeViewController)
    }

    func testInitializeModulePresenterIsSet() {
        // when
        let viewController = HomeFactory.initialize()

        // then
        XCTAssertNotNil(viewController.presenter)
    }

    func testInitializeModuleCallingTwiceReturnsDifferentInstances() {
        // when
        let first = HomeFactory.initialize()
        let second = HomeFactory.initialize()

        // then
        XCTAssertFalse(first === second)
    }
}
