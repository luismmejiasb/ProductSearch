import Combine
import UIKit

// MARK: - SearchResultFactoryProtocol

@MainActor
protocol SearchResultFactoryProtocol: AnyObject {
    static func initialize(
        homeSearchResult: ArtistSearchResult,
        searchType: SearchType,
        searchCategory: HomeCategorySearch
    ) -> SearchResultViewController
}

// MARK: - SearchResultInteractorProtocol

protocol SearchResultInteractorProtocol: AnyObject {
    var publisher: PassthroughSubject<SearchResultPublisherResult, Error> { get }

    func fetchNextPage(searchText: String, limit: Int)
    func fetchNextPageByMedia(mediaType: String, searchText: String, limit: Int)
}

// MARK: - SearchResultViewProtocol

@MainActor
protocol SearchResultViewProtocol: AnyObject {
    func displaySearchResult()
    func displayNextPageResult(_ nextPageResult: ArtistSearchResult, searchType: SearchType, searchCategory: HomeCategorySearch?)
    func endLoadingIndicator()
}

// MARK: - SearchResultRouterProtocol

@MainActor
protocol SearchResultRouterProtocol: AlertDisplayable {
    func presentFilterTypeActionSheet()
    func presentArtistDetail(_ result: ArtistResult)
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
    func fetchNextPage()
    func presentArtistDetail(_ result: ArtistResult)
    func getSearchResult() -> ArtistSearchResult?
    func setSearchResult(results: [ArtistResult]?)
    func getSearchType() -> SearchType
    func getSearchCategory() -> HomeCategorySearch
}

// MARK: - SearchResultPublisherResult

enum SearchResultPublisherResult {
    case displayNextPage(searchResult: ArtistSearchResult)
    case displayNextPageFailed(Error)
}
