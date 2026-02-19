import Foundation
@testable import ProductSearch

// MARK: - ProductDetailPresenterMock

class ProductDetailPresenterMock: ProductDetailPresenterProtocol {
    // MARK: Properties

    var functionsCalled = [String]()

    // MARK: Functions

    func displayProductDetail() {
        functionsCalled.append(#function)
    }
}
