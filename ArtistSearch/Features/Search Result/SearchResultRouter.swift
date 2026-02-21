import UIKit

// MARK: - SearchResultRouter

@MainActor
final class SearchResultRouter: SearchResultRouterProtocol {
    // MARK: Properties

    weak var view: UIViewController?
    var delegate: SearchResultRouterDelegate?

    // MARK: Functions

    func presentFilterTypeActionSheet() {
        let alert = UIAlertController(title: "Filter Results", message: "Choose how you would like to filter your search", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Lowest Price", style: .default, handler: { _ in
            self.delegate?.didSelectFilter(.lowestPrice)
        }))

        alert.addAction(UIAlertAction(title: "Highest Price", style: .default, handler: { _ in
            self.delegate?.didSelectFilter(.highestPrice)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in }))

        alert.popoverPresentationController?.sourceView = view?.view ?? UIView()

        view?.present(alert, animated: true, completion: nil)
    }

    func presentArtistDetail(_ result: ArtistResult) {
        let artistDetailViewController = ArtistDetailFactory.initialize(artist: result)

        if let navController = view?.navigationController {
            navController.pushViewController(artistDetailViewController, animated: true)
        } else {
            view?.present(artistDetailViewController, animated: true, completion: nil)
        }
    }

    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        view?.present(alert, animated: true, completion: nil)
    }
}
