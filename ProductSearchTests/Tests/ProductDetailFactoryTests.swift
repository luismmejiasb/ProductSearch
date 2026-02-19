import UIKit
import XCTest
@testable import ProductSearch

// MARK: - ProductDetailFactoryTests

@MainActor
class ProductDetailFactoryTests: XCTestCase {
    // MARK: Helpers

    private var sampleProduct: Result {
        guard let product = SearchResultMLCDataMock.multipleResults.searchResult.results?.first else {
            fatalError("ProductDetailFactoryTests: sampleProduct — results array is empty or nil in mock data")
        }
        return product
    }

    // MARK: - Tests: Factory initialization

    func testInitializeReturnsViewController() {
        // when
        let viewController = ProductDetailFactory.initialize(product: sampleProduct)

        // then
        XCTAssertNotNil(viewController)
    }

    func testInitializeReturnsCorrectType() {
        // when
        let viewController = ProductDetailFactory.initialize(product: sampleProduct)

        // then
        XCTAssertTrue(viewController is ProductDetailViewController)
    }

    func testInitializePresenterIsSet() {
        // when
        let viewController = ProductDetailFactory.initialize(product: sampleProduct)

        // then
        XCTAssertNotNil(viewController.presenter)
    }

    func testInitializeCallingTwiceReturnsDifferentInstances() {
        // when
        let first = ProductDetailFactory.initialize(product: sampleProduct)
        let second = ProductDetailFactory.initialize(product: sampleProduct)

        // then
        XCTAssertFalse(first === second)
    }
}
