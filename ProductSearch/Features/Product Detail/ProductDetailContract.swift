import UIKit

// MARK: - ProductDetailFactoryProtocol

@MainActor
protocol ProductDetailFactoryProtocol: AnyObject {
    static func initialize(product: Result) -> ProductDetailViewController
}

// MARK: - ProductDetailInteractorProtocol

protocol ProductDetailInteractorProtocol: AnyObject {
    var repository: ProductDetailRepositoryProtocol? { get set }
}

// MARK: - ProductDetailViewProtocol

@MainActor
protocol ProductDetailViewProtocol: AnyObject {
    var presenter: ProductDetailPresenterProtocol? { get set }

    func displayProductDetail(_ product: Result)
}

// MARK: - ProductDetailRouterProtocol

@MainActor
protocol ProductDetailRouterProtocol: AnyObject {
    var view: UIViewController? { get set }

    func displayAlert(title: String, message: String)
}

// MARK: - ProductDetailPresenterProtocol

@MainActor
protocol ProductDetailPresenterProtocol: AnyObject {
    var interactor: ProductDetailInteractorProtocol? { get set }
    var router: ProductDetailRouterProtocol? { get set }
    var view: ProductDetailViewProtocol? { get set }
    var product: Result { get set }

    func displayProductDetail()
}
