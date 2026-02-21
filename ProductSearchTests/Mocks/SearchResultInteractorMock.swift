import Combine
import Foundation
@testable import ArtistSearch

// MARK: - SearchResultInteractorMock

class SearchResultInteractorMock: SearchResultInteractorProtocol {
    // MARK: Properties

    let publisher: PassthroughSubject<SearchResultPublisherResult, Error>
    var functionsCalled = [String]()
    var lastLimit: Int = 0
    var lastSearchText: String = ""
    var lastMediaType: String = ""

    private let repository: SearchResultRepositoryProtocol?
    private var searchTokens = Set<AnyCancellable>()

    // MARK: Lifecycle

    init(repository: SearchResultRepositoryProtocol?, publisher: PassthroughSubject<SearchResultPublisherResult, Error>) {
        self.repository = repository
        self.publisher = publisher
    }

    // MARK: Functions

    func fetchNextPage(searchText: String, limit: Int) {
        functionsCalled.append(#function)
        lastLimit = limit
        lastSearchText = searchText
        repository?.searchArtist(searchText: searchText, limit: limit)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    switch completion {
                    case .finished: break
                    case .failure(let error):
                        self.publisher.send(.displayNextPageFailed(error))
                    }
                },
                receiveValue: { [weak self] result in
                    self?.publisher.send(.displayNextPage(searchResult: result))
                }
            )
            .store(in: &searchTokens)
    }

    func fetchNextPageByMedia(mediaType: String, searchText: String, limit: Int) {
        functionsCalled.append(#function)
        lastLimit = limit
        lastMediaType = mediaType
        lastSearchText = searchText
        repository?.searchByMedia(mediaType: mediaType, searchText: searchText, limit: limit)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    switch completion {
                    case .finished: break
                    case .failure(let error):
                        self.publisher.send(.displayNextPageFailed(error))
                    }
                },
                receiveValue: { [weak self] result in
                    self?.publisher.send(.displayNextPage(searchResult: result))
                }
            )
            .store(in: &searchTokens)
    }
}
