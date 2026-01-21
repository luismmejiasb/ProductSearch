import UIKit

// MARK: - ProductDetailFactoryProtocol

@MainActor
protocol ProductDetailFactoryProtocol: AnyObject {
    static func initialize(product: Result) -> ProductDetailViewController
}

// MARK: - ProductDetailInteractorProtocol

protocol ProductDetailInteractorProtocol: AnyObject {}

// MARK: - ProductDetailViewProtocol

@MainActor
protocol ProductDetailViewProtocol: AnyObject {
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
    func displayProductDetail()
}
