import Foundation
@testable import ProductSearch

// MARK: - ProductDetailViewMock

class ProductDetailViewMock: ProductDetailViewProtocol {
    // MARK: Properties

    var functionsCalled = [String]()
    var receivedProduct: Result?

    // MARK: Functions

    func displayProductDetail(_ product: Result) {
        functionsCalled.append(#function)
        receivedProduct = product
    }
}
