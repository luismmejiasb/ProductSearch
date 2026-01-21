// MARK: - HomeInteractor

import Combine

final class HomeInteractor: HomeInteractorProtocol {
    // MARK: Properties

    var publisher: PassthroughSubject<HomePublisherResult, Error>?

    private let repository: HomeRepositoryProtocol?
    private var searchTokens = Set<AnyCancellable>()

    // MARK: Lifecycle

    // MARK: - Inits

    init(repository: HomeRepositoryProtocol?) {
        self.repository = repository
    }

    // MARK: Functions

    func serachItem(searchText: String) {
        repository?.searchItem(offSet: 0, searchText: searchText)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.publisher?.send(HomePublisherResult.itemsSearchedWithFailure(error))
                    }
                }, receiveValue: { searchResult in
                    self.publisher?.send(HomePublisherResult.itemsSearchedWithSuccess(searchResult: searchResult))
                }
            ).store(in: &searchTokens)
    }

    func searchByCategory(_ category: HomeCategorySearch) {
        repository?.searchCategory(offSet: 0, category: category.stringValue)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.publisher?.send(HomePublisherResult.categorySearchedWithFailure(error))
                    }
                }, receiveValue: { searchResult in
                    self.publisher?.send(HomePublisherResult.categorySearchedWithSuccess(searchResult: searchResult, searchedCategory: category))
                }
            ).store(in: &searchTokens)
    }
}
