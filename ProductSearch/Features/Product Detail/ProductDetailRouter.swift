import UIKit

// MARK: - ProductDetailRouter

@MainActor
final class ProductDetailRouter: ProductDetailRouterProtocol {
    // MARK: Properties

    weak var view: UIViewController?

    // MARK: Functions

    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(
            UIAlertAction(
                title: "Aceptar",
                style: UIAlertAction.Style.default,
                handler: nil
            )
        )
        view?.present(alert, animated: true, completion: nil)
    }
}
