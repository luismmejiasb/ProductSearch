import Combine
import UIKit

// MARK: - HomeFactoryProtocol

@MainActor
protocol HomeFactoryProtocol: AnyObject {
    static func initialize() -> HomeViewController
}

// MARK: - HomeInteractorProtocol

protocol HomeInteractorProtocol: AnyObject {
    var publisher: PassthroughSubject<HomePublisherResult, Error>? { get set }

    func serachItem(searchText: String)
    func searchByCategory(_ category: HomeCategorySearch)
}

// MARK: - HomeViewProtocol

@MainActor
protocol HomeViewProtocol: AnyObject {
    func displaySearchResult(
        _ searchResults: SearchResult,
        searchType: SearchType,
        searchCategory: HomeCategorySearch
    )
    func endLoadingIndicator()
}

// MARK: - HomeRouterProtocol

@MainActor
protocol HomeRouterProtocol: AnyObject {
    func presentSearchResult(
        _ searchResult: SearchResult,
        searchType: SearchType,
        searchCategory: HomeCategorySearch
    )
    func displayAlert(title: String, message: String)
}

// MARK: - HomePresenterProtocol

@MainActor
protocol HomePresenterProtocol: AnyObject {
    func viewDidLoad()
    func searchItem(searchText: String)
    func searchByCategory(_ category: HomeCategorySearch)
    func presentSearchResult(
        _ searchResult: SearchResult,
        searchType: SearchType,
        searchCategory: HomeCategorySearch
    )
}

// MARK: - HomePublisherResult

enum HomePublisherResult {
    case itemsSearchedWithSuccess(searchResult: SearchResult)
    case itemsSearchedWithFailure(Error)
    case categorySearchedWithSuccess(searchResult: SearchResult, searchedCategory: HomeCategorySearch)
    case categorySearchedWithFailure(Error)
}

typealias HomeViewControllerProtocol = HomeViewProtocol & UIViewController
