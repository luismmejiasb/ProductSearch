import Combine

// MARK: - SearchResultInteractor

final class SearchResultInteractor: SearchResultInteractorProtocol {
    // MARK: Properties

    let publisher: PassthroughSubject<SearchResultPublisherResult, Error>
    var searchType: SearchType

    private let repository: SearchResultRepositoryProtocol?
    private var searchTokens = Set<AnyCancellable>()

    // MARK: - Inits

    init(
        repository: SearchResultRepositoryProtocol?,
        searchType: SearchType,
        publisher: PassthroughSubject<SearchResultPublisherResult, Error>
    ) {
        self.repository = repository
        self.searchType = searchType
        self.publisher = publisher
    }

    // MARK: Functions

    func fetchNextPage(searchText: String, limit: Int) {
        repository?.searchArtist(searchText: searchText, limit: limit)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.publisher.send(SearchResultPublisherResult.displayNextPageFailed(error))
                    }
                }, receiveValue: { [weak self] nextPageResult in
                    self?.publisher.send(SearchResultPublisherResult.displayNextPage(searchResult: nextPageResult))
                }
            ).store(in: &searchTokens)
    }

    func fetchNextPageByMedia(mediaType: String, searchText: String, limit: Int) {
        repository?.searchByMedia(mediaType: mediaType, searchText: searchText, limit: limit)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.publisher.send(SearchResultPublisherResult.displayNextPageFailed(error))
                    }
                }, receiveValue: { [weak self] nextPageResult in
                    self?.publisher.send(SearchResultPublisherResult.displayNextPage(searchResult: nextPageResult))
                }
            ).store(in: &searchTokens)
    }
}
