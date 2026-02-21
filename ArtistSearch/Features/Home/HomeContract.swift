import Combine
import UIKit

// MARK: - HomeFactoryProtocol

@MainActor
protocol HomeFactoryProtocol: AnyObject {
    static func initialize() -> HomeViewController
}

// MARK: - HomeInteractorProtocol

protocol HomeInteractorProtocol: AnyObject {
    var publisher: PassthroughSubject<HomePublisherResult, Error> { get }

    func searchArtist(searchText: String)
    func searchByCategory(_ category: HomeCategorySearch)
}

// MARK: - HomeViewProtocol

@MainActor
protocol HomeViewProtocol: AnyObject {
    func endLoadingIndicator()
}

// MARK: - HomeRouterProtocol

@MainActor
protocol HomeRouterProtocol: AlertDisplayable {
    func presentSearchResult(
        _ searchResult: ArtistSearchResult,
        searchType: SearchType,
        searchCategory: HomeCategorySearch
    )
}

// MARK: - HomePresenterProtocol

@MainActor
protocol HomePresenterProtocol: AnyObject {
    func viewDidLoad()
    func searchArtist(searchText: String)
    func searchByCategory(_ category: HomeCategorySearch)
}

// MARK: - HomePublisherResult

enum HomePublisherResult {
    case itemsSearchedWithSuccess(searchResult: ArtistSearchResult)
    case itemsSearchedWithFailure(Error)
    case categorySearchedWithSuccess(searchResult: ArtistSearchResult, searchedCategory: HomeCategorySearch)
    case categorySearchedWithFailure(Error)
}

typealias HomeViewControllerProtocol = HomeViewProtocol & UIViewController
