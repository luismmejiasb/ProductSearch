import UIKit

// MARK: - ProductDetailPresenter

final class ProductDetailPresenter: ProductDetailPresenterProtocol {
    // MARK: Properties

    var interactor: ProductDetailInteractorProtocol?
    var router: ProductDetailRouterProtocol?
    weak var view: ProductDetailViewProtocol?
    var product: Result

    // MARK: Lifecycle

    // MARK: - Inits

    init(interactor: ProductDetailInteractorProtocol?, router: ProductDetailRouterProtocol?, product: Result) {
        self.interactor = interactor
        self.router = router
        self.product = product
    }

    // MARK: Functions

    func displayProductDetail() {
        view?.displayProductDetail(product)
    }
}
