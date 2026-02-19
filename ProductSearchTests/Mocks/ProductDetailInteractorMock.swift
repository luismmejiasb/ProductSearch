import Foundation
@testable import ProductSearch

// MARK: - ProductDetailInteractorMock

class ProductDetailInteractorMock: ProductDetailInteractorProtocol {
    // MARK: Properties

    var functionsCalled = [String]()

    // MARK: Lifecycle

    init() {}
}
