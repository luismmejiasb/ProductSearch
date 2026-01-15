import Combine

// MARK: - SearchResultInteractor

final class SearchResultInteractor: SearchResultInteractorProtocol {
    // MARK: Properties

    var repository: SearchResultRepositoryProtocol?
    var publisher: PassthroughSubject<SearchResultPublisherResult, Error>?
    var searchType: SearchType

    private var searchTokens = Set<AnyCancellable>()

    // MARK: Lifecycle

    // MARK: - Inits

    init(repository: SearchResultRepositoryProtocol?, searchType: SearchType) {
        self.repository = repository
        self.searchType = searchType
    }

    // MARK: Functions

    func fetchNextOffSet(_ offSet: Int, searchText: String) {
        repository?.searchItem(offSet: offSet, searchText: searchText)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.publisher?.send(SearchResultPublisherResult.displayNextOffSetFailed(error))
                    }
                }, receiveValue: { nextOffSetResult in
                    self.publisher?.send(SearchResultPublisherResult.displayNextOffSet(searchResult: nextOffSetResult))
                }
            ).store(in: &searchTokens)
    }

    func fetchNextOffSet(_ offSet: Int, category: String) {
        repository?.searchCategory(offSet: offSet, category: category)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.publisher?.send(SearchResultPublisherResult.displayNextOffSetFailed(error))
                    }
                }, receiveValue: { nextOffSetResult in
                    self.publisher?.send(SearchResultPublisherResult.displayNextOffSet(searchResult: nextOffSetResult))
                }
            ).store(in: &searchTokens)
    }
}
