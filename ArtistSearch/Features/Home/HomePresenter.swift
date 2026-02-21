import Combine
import UIKit

// MARK: - HomePresenter

@MainActor
final class HomePresenter: HomePresenterProtocol {
    // MARK: Properties

    weak var view: HomeViewControllerProtocol?

    private let interactor: HomeInteractorProtocol
    private let router: HomeRouterProtocol

    private var searchItemsTokens = Set<AnyCancellable>()

    // MARK: Lifecycle

    // MARK: - Inits

    init(interactor: HomeInteractorProtocol, router: HomeRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    // MARK: Functions

    func viewDidLoad() {
        registerToInteractorPublisher()
    }

    func searchArtist(searchText: String) {
        interactor.searchArtist(searchText: searchText)
    }

    func searchByCategory(_ category: HomeCategorySearch) {
        interactor.searchByCategory(category)
    }
}

// MARK: Interactor publisher subscription

private extension HomePresenter {
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
                switch result {
                case .itemsSearchedWithSuccess(let searchResult):
                    self?.view?.endLoadingIndicator()
                    self?.router.presentSearchResult(
                        searchResult,
                        searchType: .text,
                        searchCategory: .none
                    )
                case .itemsSearchedWithFailure(let error):
                    self?.view?.endLoadingIndicator()
                    self?.displayError(error)
                case .categorySearchedWithSuccess(let searchResult, let searchedCategory):
                    self?.view?.endLoadingIndicator()
                    self?.router.presentSearchResult(
                        searchResult,
                        searchType: .category,
                        searchCategory: searchedCategory
                    )
                case .categorySearchedWithFailure(let error):
                    self?.view?.endLoadingIndicator()
                    self?.displayError(error)
                }
            }
        ).store(in: &searchItemsTokens)
    }

    private func displayError(_ error: Error) {
        PresenterErrorHandler.handle(error, with: router)
    }
}
