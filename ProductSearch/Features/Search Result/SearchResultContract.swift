import Combine
import UIKit

// MARK: - SearchResultFactoryProtocol

@MainActor
protocol SearchResultFactoryProtocol: AnyObject {
    static func initialize(
        homeSearchResult: SearchResult,
        searchType: SearchType,
        searchCategory: HomeCategorySearch
    ) -> SearchResultViewController
}

// MARK: - SearchResultInteractorProtocol

protocol SearchResultInteractorProtocol: AnyObject {func fetchNextOffSet(_ offSet: Int, searchText: String)
    var publisher: PassthroughSubject<SearchResultPublisherResult, Error>? { get set }
    
    func fetchNextOffSet(_ offSet: Int, category: String)
}

// MARK: - SearchResultViewProtocol

@MainActor
protocol SearchResultViewProtocol: AnyObject {func displaySearchResult()
    func displayNextOffSetResult(_ nextOffSetResult: SearchResult, searchType: SearchType, searchCategory: HomeCategorySearch?)
    func endLoadingIndicator()
}

// MARK: - SearchResultRouterProtocol

@MainActor
protocol SearchResultRouterProtocol: AnyObject {func presentFilterTypeActionSheet()
    func presentProductDetail(_ result: Result)
    func displayAlert(title: String, message: String)
}

// MARK: - SearchResultRouterDelegate

@MainActor
protocol SearchResultRouterDelegate: AnyObject {
    func didSelectFilter(_ filter: FilterType)
}

// MARK: - SearchResultPresenterProtocol

@MainActor
protocol SearchResultPresenterProtocol: AnyObject {
    func viewDidLoad()
    func presentFilterTypeActionSheet()
    func fetchNextOffSet()
    func presentProductDetail(_ result: Result)
    func getSearchResult() -> SearchResult?
    func setSearchResult(results: [Result]?)
    func getSearchType() -> SearchType
    func getSearchCategory() -> HomeCategorySearch
}

// MARK: - SearchResultPublisherResult

enum SearchResultPublisherResult {
    case displayNextOffSet(searchResult: SearchResult)
    case displayNextOffSetFailed(Error)
}

// MARK: - FilterType

enum FilterType {
    case lowestPrice
    case highestPrice
}

// MARK: - SearchType

enum SearchType {
    case text
    case category
}
