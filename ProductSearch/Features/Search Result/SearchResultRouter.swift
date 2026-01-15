import UIKit

// MARK: - SearchResultRouter

final class SearchResultRouter: SearchResultRouterProtocol {
    // MARK: Properties

    weak var view: UIViewController?
    var delegate: SearchResultRouterDelegate?

    // MARK: Functions

    func presentFilterTypeActionSheet() {
        let alert = UIAlertController(title: "Filtrar contenido", message: "Elige la forma en la que te gustaria filtrar tu búsqueda", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Menor precio", style: .default, handler: { _ in
            self.delegate?.didSelectFilter(.lowestPrice)
        }))

        alert.addAction(UIAlertAction(title: "Mayor precio", style: .default, handler: { _ in
            self.delegate?.didSelectFilter(.highestPrice)
        }))

        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { _ in }))

        alert.popoverPresentationController?.sourceView = view?.view ?? UIView()

        view?.present(alert, animated: true, completion: {
            // We can add a tag here if we want to track how many times is being the Filter actionSheet presented
        })
    }

    func presentProductDetail(_ result: Result) {
        let productDetailViewController = ProductDetailFactory.initialize(product: result)

        if let navController = view?.navigationController {
            navController.pushViewController(productDetailViewController, animated: true)
        } else {
            view?.present(productDetailViewController, animated: true, completion: nil)
        }
    }

    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
        view?.present(alert, animated: true, completion: nil)
    }
}
