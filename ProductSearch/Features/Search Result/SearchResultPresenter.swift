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
    private var searchResult: SearchResult
    private var searchType: SearchType
    private let searchCategory: HomeCategorySearch
    private let searchText: String
    private var searchItemsTokens = Set<AnyCancellable>()
    private var offSet: Int = 0

    // MARK: Lifecycle

    // MARK: - Inits

    init(
        interactor: SearchResultInteractorProtocol,
        router: SearchResultRouterProtocol,
        searchResult: SearchResult,
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

    func fetchNextOffSet() {
        offSet = offSet + pagingLength
        if searchType == .text {
            interactor.fetchNextOffSet(offSet, searchText: searchText)
        } else {
            interactor.fetchNextOffSet(offSet, category: searchCategory.stringValue)
        }
    }

    func presentProductDetail(_ result: Result) {
        router.presentProductDetail(result)
    }

    func getSearchResult() -> SearchResult? {
        searchResult
    }

    func setSearchResult(results: [Result]?) {
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
        interactor.publisher?.sink(
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
                case .displayNextOffSet(let nextOffSetResults):
                    self.view?.endLoadingIndicator()
                    self.view?.displayNextOffSetResult(
                        nextOffSetResults,
                        searchType: self.searchType,
                        searchCategory: self.searchCategory
                    )
                case .displayNextOffSetFailed(let error):
                    self.view?.endLoadingIndicator()
                    self.displayError(error)
                }
            }
        ).store(in: &searchItemsTokens)
    }

    private func displayError(_ error: Error) {
        if let error = error as? CloudDataSourceDefaultError {
            switch error {
            case .httpError:
                router.displayAlert(
                    title: "Error",
                    message: "Tuvimos un error con nuestros servicios. Por favor, intenta nuevamente más tarde."
                )
            default:
                router.displayAlert(
                    title: "Error en tu busqueda",
                    message: "No pudimos continuar con tu búsqueda. Por favor, intento nuevamente o con otra descripción de tu producto"
                )
            }
        }
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
            searchResult.results = searchResults.sorted { $0.price ?? 0 < $1.price ?? 0 }
            view?.displaySearchResult()
        case .highestPrice:
            searchResult.results = searchResults.sorted { $0.price ?? 0 > $1.price ?? 0 }
        }

        view?.displaySearchResult()
    }
}
