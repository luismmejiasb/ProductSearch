import Combine
import XCTest
@testable import ArtistSearch

// MARK: - SearchResultInteractorTests

class SearchResultInteractorTests: XCTestCase {
    // MARK: Properties

    private var searchTokens = Set<AnyCancellable>()
    private let fetchNextPageSelectorName = "fetchNextPage(searchText:limit:)"
    private let fetchNextPageByMediaSelectorName = "fetchNextPageByMedia(mediaType:searchText:limit:)"

    // MARK: Overridden Functions

    override func tearDown() {
        super.tearDown()
        searchTokens.removeAll()
    }

    // MARK: Helpers

    private func makeInteractor(
        status: TransactionStatus,
        searchType: SearchType = .text,
        mockData: SearchResultITunesDataMock = .multipleResults
    ) -> (SearchResultInteractor, SearchResultRepositoryMock, PassthroughSubject<SearchResultPublisherResult, Error>) {
        let cloudDataSourceMock = SearchResultCloudDataSourceMock(status: status, mockData: mockData)
        let localDataSourceMock = SearchResultLocalDataSourceMock()
        let repositoryMock = SearchResultRepositoryMock(
            localDataSource: localDataSourceMock,
            cloudDataSource: cloudDataSourceMock
        )
        let publisher = PassthroughSubject<SearchResultPublisherResult, Error>()
        let interactor = SearchResultInteractor(repository: repositoryMock, searchType: searchType, publisher: publisher)
        return (interactor, repositoryMock, publisher)
    }

    // MARK: - Tests: fetchNextPage (text search)

    func testFetchNextPageWithSuccessPublishesDisplayNextPage() {
        // given
        let (interactor, repositoryMock, publisher) = makeInteractor(status: .success)
        var receivedResult: ArtistSearchResult?

        publisher.sink(
            receiveCompletion: { _ in },
            receiveValue: { result in
                switch result {
                case .displayNextPage(let searchResult):
                    receivedResult = searchResult
                case .displayNextPageFailed:
                    XCTFail("Expected success, got failure")
                }
            }
        ).store(in: &searchTokens)

        // when
        interactor.fetchNextPage(searchText: "Jack Johnson", limit: 50)

        XCTAssertNotNil(receivedResult)
        XCTAssertEqual(repositoryMock.functionsCalled.count, 1)
        XCTAssertEqual(repositoryMock.functionsCalled[0], "searchArtist(searchText:limit:)")
    }

    func testFetchNextPageWithSuccessPassesCorrectSearchText() {
        // given
        let (interactor, repositoryMock, _) = makeInteractor(status: .success)

        // when
        interactor.fetchNextPage(searchText: "Coldplay", limit: 100)

        // then
        XCTAssertEqual(repositoryMock.lastSearchText, "Coldplay")
    }

    func testFetchNextPageWithFailurePublishesDisplayNextPageFailed() {
        // given
        let (interactor, repositoryMock, publisher) = makeInteractor(status: .failure)
        var receivedError: Error?

        publisher.sink(
            receiveCompletion: { _ in },
            receiveValue: { result in
                switch result {
                case .displayNextPageFailed(let error):
                    receivedError = error
                case .displayNextPage:
                    XCTFail("Expected failure, got success")
                }
            }
        ).store(in: &searchTokens)

        // when
        interactor.fetchNextPage(searchText: "Jack Johnson", limit: 50)

        XCTAssertNotNil(receivedError)
        XCTAssertEqual(repositoryMock.functionsCalled.count, 1)
    }

    func testFetchNextPageWithLimit150PassesLimit() {
        // given
        let (interactor, repositoryMock, _) = makeInteractor(status: .success)

        // when
        interactor.fetchNextPage(searchText: "Adele", limit: 150)

        // then
        XCTAssertEqual(repositoryMock.lastSearchText, "Adele")
        XCTAssertEqual(repositoryMock.functionsCalled.count, 1)
    }

    // MARK: - Tests: fetchNextPageByMedia (category search)

    func testFetchNextPageByMediaWithSuccessPublishesDisplayNextPage() {
        // given
        let (interactor, repositoryMock, publisher) = makeInteractor(status: .success)
        var receivedResult: ArtistSearchResult?

        publisher.sink(
            receiveCompletion: { _ in },
            receiveValue: { result in
                switch result {
                case .displayNextPage(let searchResult):
                    receivedResult = searchResult
                case .displayNextPageFailed:
                    XCTFail("Expected success, got failure")
                }
            }
        ).store(in: &searchTokens)

        // when
        interactor.fetchNextPageByMedia(mediaType: HomeCategorySearch.reggaeton.mediaType, searchText: "Reggaeton", limit: 50)

        XCTAssertNotNil(receivedResult)
        XCTAssertEqual(repositoryMock.functionsCalled.count, 1)
        XCTAssertEqual(repositoryMock.functionsCalled[0], "searchByMedia(mediaType:searchText:limit:)")
    }

    func testFetchNextPageByMediaWithSuccessPassesCorrectMediaTypeAndOffset() {
        // given
        let (interactor, repositoryMock, _) = makeInteractor(status: .success)

        // when
        interactor.fetchNextPageByMedia(mediaType: HomeCategorySearch.salsa.mediaType, searchText: "Salsa", limit: 150)

        // then
        XCTAssertEqual(repositoryMock.lastMediaType, HomeCategorySearch.salsa.mediaType)
    }

    func testFetchNextPageByMediaWithFailurePublishesDisplayNextPageFailed() {
        // given
        let (interactor, repositoryMock, publisher) = makeInteractor(status: .failure)
        var receivedError: Error?

        publisher.sink(
            receiveCompletion: { _ in },
            receiveValue: { result in
                switch result {
                case .displayNextPageFailed(let error):
                    receivedError = error
                case .displayNextPage:
                    XCTFail("Expected failure, got success")
                }
            }
        ).store(in: &searchTokens)

        // when
        interactor.fetchNextPageByMedia(mediaType: HomeCategorySearch.rock.mediaType, searchText: "Rock", limit: 50)

        XCTAssertNotNil(receivedError)
        XCTAssertEqual(repositoryMock.functionsCalled.count, 1)
    }

    // MARK: - Tests: publisher receives values

    func testFetchNextPagePublishesResult() {
        // given
        let (interactor, repositoryMock, publisher) = makeInteractor(status: .success)
        var receivedResult: ArtistSearchResult?

        publisher.sink(
            receiveCompletion: { _ in },
            receiveValue: { result in
                if case .displayNextPage(let searchResult) = result {
                    receivedResult = searchResult
                }
            }
        ).store(in: &searchTokens)

        // when
        interactor.fetchNextPage(searchText: "Test", limit: 50)

        // then
        XCTAssertNotNil(receivedResult)
        XCTAssertEqual(repositoryMock.functionsCalled.count, 1)
    }

    func testFetchNextPageByMediaPublishesResult() {
        // given
        let (interactor, repositoryMock, publisher) = makeInteractor(status: .success)
        var receivedResult: ArtistSearchResult?

        publisher.sink(
            receiveCompletion: { _ in },
            receiveValue: { result in
                if case .displayNextPage(let searchResult) = result {
                    receivedResult = searchResult
                }
            }
        ).store(in: &searchTokens)

        // when
        interactor.fetchNextPageByMedia(mediaType: HomeCategorySearch.reggaeton.mediaType, searchText: "Reggaeton", limit: 50)

        // then
        XCTAssertNotNil(receivedResult)
        XCTAssertEqual(repositoryMock.functionsCalled.count, 1)
    }

    // MARK: - Tests: successive calls

    func testMultipleFetchNextPageCallsRepositoryEachTime() {
        // given
        let (interactor, repositoryMock, _) = makeInteractor(status: .success)

        // when
        interactor.fetchNextPage(searchText: "Jack Johnson", limit: 50)
        interactor.fetchNextPage(searchText: "Jack Johnson", limit: 100)
        interactor.fetchNextPage(searchText: "Jack Johnson", limit: 150)

        // then
        XCTAssertEqual(repositoryMock.functionsCalled.count, 3)
    }

    // MARK: - Tests: multiple results

    func testFetchNextPageWithSuccessResultsAreNotEmpty() {
        // given
        let (interactor, _, publisher) = makeInteractor(status: .success, mockData: .multipleResults)
        var resultCount = 0

        publisher.sink(
            receiveCompletion: { _ in },
            receiveValue: { result in
                if case .displayNextPage(let searchResult) = result {
                    resultCount = searchResult.results?.count ?? 0
                }
            }
        ).store(in: &searchTokens)

        // when
        interactor.fetchNextPage(searchText: "iphone", limit: 50)

        XCTAssertGreaterThan(resultCount, 0)
    }
}
