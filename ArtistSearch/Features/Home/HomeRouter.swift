import UIKit

// MARK: - HomeRouter

@MainActor
final class HomeRouter: HomeRouterProtocol {
    // MARK: Properties

    weak var view: HomeViewControllerProtocol?

    // MARK: Functions

    func presentSearchResult(
        _ searchResult: ArtistSearchResult,
        searchType: SearchType,
        searchCategory: HomeCategorySearch
    ) {
        let searchResultViewController = SearchResultFactory.initialize(
            homeSearchResult: searchResult,
            searchType: searchType,
            searchCategory: searchCategory
        )

        if let navController = view?.navigationController {
            navController.pushViewController(searchResultViewController, animated: true)
        } else {
            view?.present(searchResultViewController, animated: true, completion: nil)
        }
    }

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
