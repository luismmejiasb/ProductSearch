import UIKit
import XCTest
@testable import ProductSearch

class HomeFactoryTest: XCTestCase {
    func testInitializeModule() {
        XCTAssertNotNil(HomeFactory.initialize())
    }
}
