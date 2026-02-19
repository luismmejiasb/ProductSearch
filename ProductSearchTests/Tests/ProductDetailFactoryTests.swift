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

    func testInitialize_returnsViewController() {
        let viewController = ProductDetailFactory.initialize(product: sampleProduct)
        XCTAssertNotNil(viewController)
    }

    func testInitialize_returnsCorrectType() {
        let viewController = ProductDetailFactory.initialize(product: sampleProduct)
        XCTAssertTrue(viewController is ProductDetailViewController)
    }

    func testInitialize_presenterIsSet() {
        let viewController = ProductDetailFactory.initialize(product: sampleProduct)
        XCTAssertNotNil(viewController.presenter)
    }

    func testInitialize_callingTwiceReturnsDifferentInstances() {
        let first = ProductDetailFactory.initialize(product: sampleProduct)
        let second = ProductDetailFactory.initialize(product: sampleProduct)
        XCTAssertFalse(first === second)
    }
}
