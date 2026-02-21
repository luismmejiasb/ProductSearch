import Combine
import UIKit

// MARK: - SearchResultPresenter

@MainActor
final class SearchResultPresenter: SearchResultPresenterProtocol {
    // MARK: Properties

    weak var view: SearchResultViewProtocol?

    private let interactor: SearchResultInteractorProtocol
    private let router: SearchResultRouterProtocol
    private let pagingLength = 50
    private var searchResult: ArtistSearchResult
    private var searchType: SearchType
    private let searchCategory: HomeCategorySearch
    private let searchText: String
    private var searchItemsTokens = Set<AnyCancellable>()

    // MARK: Lifecycle

    // MARK: - Inits

    init(
        interactor: SearchResultInteractorProtocol,
        router: SearchResultRouterProtocol,
        searchResult: ArtistSearchResult,
        searchType: SearchType,
        searchCategory: HomeCategorySearch,
        searchText: String
    ) {
        self.interactor = interactor
        self.router = router
        self.searchType = searchType
        self.searchResult = searchResult
        self.searchCategory = searchCategory
        self.searchText = searchText
    }

    // MARK: Functions

    func viewDidLoad() {
        registerToInteractorPublisher()
    }

    func presentFilterTypeActionSheet() {
        router.presentFilterTypeActionSheet()
    }

    func fetchNextPage() {
        let nextLimit = (searchResult.resultCount ?? 0) + pagingLength
        if searchType == .text {
            interactor.fetchNextPage(searchText: searchText, limit: nextLimit)
        } else {
            interactor.fetchNextPageByMedia(
                mediaType: searchCategory.mediaType,
                searchText: searchCategory.uiTitle,
                limit: nextLimit
            )
        }
    }

    func presentArtistDetail(_ result: ArtistResult) {
        router.presentArtistDetail(result)
    }

    func getSearchResult() -> ArtistSearchResult? {
        searchResult
    }

    func setSearchResult(results: [ArtistResult]?) {
        searchResult.results = results
    }

    func getSearchType() -> SearchType {
        searchType
    }

    func getSearchCategory() -> HomeCategorySearch {
        searchCategory
    }
}

// MARK: Interactor publisher subscription

private extension SearchResultPresenter {
    private func registerToInteractorPublisher() {
        interactor.publisher.sink(
            receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.view?.endLoadingIndicator()
                case .failure(let error):
                    self?.view?.endLoadingIndicator()
                    self?.displayError(error)
                }
            }, receiveValue: { [weak self] result in
                guard let self else {
                    return
                }
                switch result {
                case .displayNextPage(let nextPageResults):
                    self.view?.endLoadingIndicator()
                    self.view?.displayNextPageResult(
                        nextPageResults,
                        searchType: self.searchType,
                        searchCategory: self.searchCategory
                    )
                case .displayNextPageFailed(let error):
                    self.view?.endLoadingIndicator()
                    self.displayError(error)
                }
            }
        ).store(in: &searchItemsTokens)
    }

    private func displayError(_ error: Error) {
        PresenterErrorHandler.handle(error, with: router)
    }
}

// MARK: Router Delegate

@MainActor
extension SearchResultPresenter: SearchResultRouterDelegate {
    func didSelectFilter(_ filter: FilterType) {
        guard let searchResults = searchResult.results else {
            return
        }

        switch filter {
        case .lowestPrice:
            searchResult.results = searchResults.sorted { ($0.trackPrice ?? 0) < ($1.trackPrice ?? 0) }
            view?.displaySearchResult()
        case .highestPrice:
            searchResult.results = searchResults.sorted { ($0.trackPrice ?? 0) > ($1.trackPrice ?? 0) }
        }

        view?.displaySearchResult()
    }
}
