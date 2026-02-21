import UIKit

// MARK: - ArtistDetailRouter

@MainActor
final class ArtistDetailRouter: ArtistDetailRouterProtocol {
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
                title: "OK",
                style: UIAlertAction.Style.default,
                handler: nil
            )
        )
        view?.present(alert, animated: true, completion: nil)
    }
}

