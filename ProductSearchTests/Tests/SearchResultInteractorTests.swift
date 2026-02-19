import Combine
import XCTest
@testable import ProductSearch

// MARK: - SearchResultInteractorTests

class SearchResultInteractorTests: XCTestCase {
    // MARK: Properties

    private var searchTokens = Set<AnyCancellable>()
    private let searchItemSelectorName = "searchItem(offSet:searchText:)"
    private let searchCategorySelectorName = "searchCategory(offSet:category:)"

    // MARK: Overridden Functions

    override func tearDown() {
        super.tearDown()
        searchTokens.removeAll()
    }

    // MARK: Helpers

    private func makeInteractor(
        status: TransactionStatus,
        searchType: SearchType = .text,
        mockData: SearchResultMLCDataMock = .multipleResults
    ) -> (SearchResultInteractor, SearchResultRepositoryMock, PassthroughSubject<SearchResultPublisherResult, Error>) {
        let cloudDataSourceMock = SearchResultCloudDataSourceMock(status: status, mockData: mockData)
        let localDataSourceMock = SearchResultLocalDataSourceMock()
        let repositoryMock = SearchResultRepositoryMock(
            status: status,
            localDataSource: localDataSourceMock,
            cloudDataSource: cloudDataSourceMock
        )
        let publisher = PassthroughSubject<SearchResultPublisherResult, Error>()
        let interactor = SearchResultInteractor(repository: repositoryMock, searchType: searchType)
        interactor.publisher = publisher
        return (interactor, repositoryMock, publisher)
    }

    // MARK: - Tests: fetchNextOffSet searchText

    func testFetchNextOffSetSearchTextWithSuccessPublishesDisplayNextOffSet() {
        // given
        let (interactor, repositoryMock, publisher) = makeInteractor(status: .success)
        var receivedResult: SearchResult?

        publisher.sink(
            receiveCompletion: { _ in },
            receiveValue: { result in
                // then
                switch result {
                case .displayNextOffSet(let searchResult):
                    receivedResult = searchResult
                case .displayNextOffSetFailed:
                    XCTFail("Expected success, got failure")
                }
            }
        ).store(in: &searchTokens)

        // when
        interactor.fetchNextOffSet(50, searchText: "iPhone")

        XCTAssertNotNil(receivedResult)
        XCTAssertEqual(repositoryMock.functionsCalled.count, 1)
        XCTAssertEqual(repositoryMock.functionsCalled[0], searchItemSelectorName)
    }

    func testFetchNextOffSetSearchTextWithSuccessPassesCorrectOffset() {
        // given
        let (interactor, repositoryMock, _) = makeInteractor(status: .success)

        // when
        interactor.fetchNextOffSet(100, searchText: "MacBook")

        // then
        XCTAssertEqual(repositoryMock.lastOffSet, 100)
        XCTAssertEqual(repositoryMock.lastSearchText, "MacBook")
    }

    func testFetchNextOffSetSearchTextWithFailurePublishesDisplayNextOffSetFailed() {
        // given
        let (interactor, repositoryMock, publisher) = makeInteractor(status: .failure)
        var receivedError: Error?

        publisher.sink(
            receiveCompletion: { _ in },
            receiveValue: { result in
                // then
                switch result {
                case .displayNextOffSetFailed(let error):
                    receivedError = error
                case .displayNextOffSet:
                    XCTFail("Expected failure, got success")
                }
            }
        ).store(in: &searchTokens)

        // when
        interactor.fetchNextOffSet(50, searchText: "iPhone")

        XCTAssertNotNil(receivedError)
        XCTAssertEqual(repositoryMock.functionsCalled.count, 1)
    }

    func testFetchNextOffSetSearchTextWithOffset0() {
        // given
        let (interactor, repositoryMock, _) = makeInteractor(status: .success)

        // when
        interactor.fetchNextOffSet(0, searchText: "iPad")

        // then
        XCTAssertEqual(repositoryMock.lastOffSet, 0)
    }

    // MARK: - Tests: fetchNextOffSet category

    func testFetchNextOffSetCategoryWithSuccessPublishesDisplayNextOffSet() {
        // given
        let (interactor, repositoryMock, publisher) = makeInteractor(status: .success)
        var receivedResult: SearchResult?

        publisher.sink(
            receiveCompletion: { _ in },
            receiveValue: { result in
                // then
                switch result {
                case .displayNextOffSet(let searchResult):
                    receivedResult = searchResult
                case .displayNextOffSetFailed:
                    XCTFail("Expected success, got failure")
                }
            }
        ).store(in: &searchTokens)

        // when
        interactor.fetchNextOffSet(50, category: HomeCategorySearch.vehicule.stringValue)

        XCTAssertNotNil(receivedResult)
        XCTAssertEqual(repositoryMock.functionsCalled.count, 1)
        XCTAssertEqual(repositoryMock.functionsCalled[0], searchCategorySelectorName)
    }

    func testFetchNextOffSetCategoryWithSuccessPassesCorrectCategoryAndOffset() {
        // given
        let (interactor, repositoryMock, _) = makeInteractor(status: .success)

        // when
        interactor.fetchNextOffSet(150, category: HomeCategorySearch.realState.stringValue)

        // then
        XCTAssertEqual(repositoryMock.lastOffSet, 150)
        XCTAssertEqual(repositoryMock.lastCategory, HomeCategorySearch.realState.stringValue)
    }

    func testFetchNextOffSetCategoryWithFailurePublishesDisplayNextOffSetFailed() {
        // given
        let (interactor, repositoryMock, publisher) = makeInteractor(status: .failure)
        var receivedError: Error?

        publisher.sink(
            receiveCompletion: { _ in },
            receiveValue: { result in
                // then
                switch result {
                case .displayNextOffSetFailed(let error):
                    receivedError = error
                case .displayNextOffSet:
                    XCTFail("Expected failure, got success")
                }
            }
        ).store(in: &searchTokens)

        // when
        interactor.fetchNextOffSet(50, category: HomeCategorySearch.services.stringValue)

        XCTAssertNotNil(receivedError)
        XCTAssertEqual(repositoryMock.functionsCalled.count, 1)
    }

    // MARK: - Tests: publisher nil does not crash

    func testFetchNextOffSetSearchTextWithNilPublisherDoesNotCrash() {
        // given
        let (interactor, repositoryMock, _) = makeInteractor(status: .success)
        interactor.publisher = nil

        // when
        interactor.fetchNextOffSet(0, searchText: "Test")

        // then
        XCTAssertEqual(repositoryMock.functionsCalled.count, 1)
    }

    func testFetchNextOffSetCategoryWithNilPublisherDoesNotCrash() {
        // given
        let (interactor, repositoryMock, _) = makeInteractor(status: .success)
        interactor.publisher = nil

        // when
        interactor.fetchNextOffSet(0, category: HomeCategorySearch.vehicule.stringValue)

        // then
        XCTAssertEqual(repositoryMock.functionsCalled.count, 1)
    }

    // MARK: - Tests: successive calls increment offset

    func testMultipleSearchTextCallsRepositoryEachTime() {
        // given
        let (interactor, repositoryMock, _) = makeInteractor(status: .success)

        // when
        interactor.fetchNextOffSet(50, searchText: "iPhone")
        interactor.fetchNextOffSet(100, searchText: "iPhone")
        interactor.fetchNextOffSet(150, searchText: "iPhone")

        // then
        XCTAssertEqual(repositoryMock.functionsCalled.count, 3)
        XCTAssertEqual(repositoryMock.lastOffSet, 150)
    }

    // MARK: - Tests: multiple results

    func testFetchNextOffSetSearchTextWithSuccessResultsAreNotEmpty() {
        // given
        let (interactor, _, publisher) = makeInteractor(status: .success, mockData: .multipleResults)
        var resultCount = 0

        publisher.sink(
            receiveCompletion: { _ in },
            receiveValue: { result in
                // then
                if case .displayNextOffSet(let searchResult) = result {
                    resultCount = searchResult.results?.count ?? 0
                }
            }
        ).store(in: &searchTokens)

        // when
        interactor.fetchNextOffSet(0, searchText: "iPhone")

        XCTAssertGreaterThan(resultCount, 0)
    }
}
