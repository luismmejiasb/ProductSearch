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

    func testFetchNextOffSet_searchText_withSuccess_publishesDisplayNextOffSet() {
        let (interactor, repositoryMock, publisher) = makeInteractor(status: .success)
        var receivedResult: SearchResult?

        publisher.sink(
            receiveCompletion: { _ in },
            receiveValue: { result in
                switch result {
                case .displayNextOffSet(let searchResult):
                    receivedResult = searchResult
                case .displayNextOffSetFailed:
                    XCTFail("Expected success, got failure")
                }
            }
        ).store(in: &searchTokens)

        interactor.fetchNextOffSet(50, searchText: "iPhone")

        XCTAssertNotNil(receivedResult)
        XCTAssertEqual(repositoryMock.functionsCalled.count, 1)
        XCTAssertEqual(repositoryMock.functionsCalled[0], searchItemSelectorName)
    }

    func testFetchNextOffSet_searchText_withSuccess_passesCorrectOffset() {
        let (interactor, repositoryMock, _) = makeInteractor(status: .success)

        interactor.fetchNextOffSet(100, searchText: "MacBook")

        XCTAssertEqual(repositoryMock.lastOffSet, 100)
        XCTAssertEqual(repositoryMock.lastSearchText, "MacBook")
    }

    func testFetchNextOffSet_searchText_withFailure_publishesDisplayNextOffSetFailed() {
        let (interactor, repositoryMock, publisher) = makeInteractor(status: .failure)
        var receivedError: Error?

        publisher.sink(
            receiveCompletion: { _ in },
            receiveValue: { result in
                switch result {
                case .displayNextOffSetFailed(let error):
                    receivedError = error
                case .displayNextOffSet:
                    XCTFail("Expected failure, got success")
                }
            }
        ).store(in: &searchTokens)

        interactor.fetchNextOffSet(50, searchText: "iPhone")

        XCTAssertNotNil(receivedError)
        XCTAssertEqual(repositoryMock.functionsCalled.count, 1)
    }

    func testFetchNextOffSet_searchText_withOffset0() {
        let (interactor, repositoryMock, _) = makeInteractor(status: .success)

        interactor.fetchNextOffSet(0, searchText: "iPad")

        XCTAssertEqual(repositoryMock.lastOffSet, 0)
    }

    // MARK: - Tests: fetchNextOffSet category

    func testFetchNextOffSet_category_withSuccess_publishesDisplayNextOffSet() {
        let (interactor, repositoryMock, publisher) = makeInteractor(status: .success)
        var receivedResult: SearchResult?

        publisher.sink(
            receiveCompletion: { _ in },
            receiveValue: { result in
                switch result {
                case .displayNextOffSet(let searchResult):
                    receivedResult = searchResult
                case .displayNextOffSetFailed:
                    XCTFail("Expected success, got failure")
                }
            }
        ).store(in: &searchTokens)

        interactor.fetchNextOffSet(50, category: HomeCategorySearch.vehicule.stringValue)

        XCTAssertNotNil(receivedResult)
        XCTAssertEqual(repositoryMock.functionsCalled.count, 1)
        XCTAssertEqual(repositoryMock.functionsCalled[0], searchCategorySelectorName)
    }

    func testFetchNextOffSet_category_withSuccess_passesCorrectCategoryAndOffset() {
        let (interactor, repositoryMock, _) = makeInteractor(status: .success)

        interactor.fetchNextOffSet(150, category: HomeCategorySearch.realState.stringValue)

        XCTAssertEqual(repositoryMock.lastOffSet, 150)
        XCTAssertEqual(repositoryMock.lastCategory, HomeCategorySearch.realState.stringValue)
    }

    func testFetchNextOffSet_category_withFailure_publishesDisplayNextOffSetFailed() {
        let (interactor, repositoryMock, publisher) = makeInteractor(status: .failure)
        var receivedError: Error?

        publisher.sink(
            receiveCompletion: { _ in },
            receiveValue: { result in
                switch result {
                case .displayNextOffSetFailed(let error):
                    receivedError = error
                case .displayNextOffSet:
                    XCTFail("Expected failure, got success")
                }
            }
        ).store(in: &searchTokens)

        interactor.fetchNextOffSet(50, category: HomeCategorySearch.services.stringValue)

        XCTAssertNotNil(receivedError)
        XCTAssertEqual(repositoryMock.functionsCalled.count, 1)
    }

    // MARK: - Tests: publisher nil does not crash

    func testFetchNextOffSet_searchText_withNilPublisher_doesNotCrash() {
        let (interactor, repositoryMock, _) = makeInteractor(status: .success)
        interactor.publisher = nil

        interactor.fetchNextOffSet(0, searchText: "Test")

        XCTAssertEqual(repositoryMock.functionsCalled.count, 1)
    }

    func testFetchNextOffSet_category_withNilPublisher_doesNotCrash() {
        let (interactor, repositoryMock, _) = makeInteractor(status: .success)
        interactor.publisher = nil

        interactor.fetchNextOffSet(0, category: HomeCategorySearch.vehicule.stringValue)

        XCTAssertEqual(repositoryMock.functionsCalled.count, 1)
    }

    // MARK: - Tests: successive calls increment offset

    func testMultipleSearchText_callsRepository_eachTime() {
        let (interactor, repositoryMock, _) = makeInteractor(status: .success)

        interactor.fetchNextOffSet(50, searchText: "iPhone")
        interactor.fetchNextOffSet(100, searchText: "iPhone")
        interactor.fetchNextOffSet(150, searchText: "iPhone")

        XCTAssertEqual(repositoryMock.functionsCalled.count, 3)
        XCTAssertEqual(repositoryMock.lastOffSet, 150)
    }

    // MARK: - Tests: multiple results

    func testFetchNextOffSet_searchText_withSuccess_resultsAreNotEmpty() {
        let (interactor, _, publisher) = makeInteractor(status: .success, mockData: .multipleResults)
        var resultCount = 0

        publisher.sink(
            receiveCompletion: { _ in },
            receiveValue: { result in
                if case .displayNextOffSet(let searchResult) = result {
                    resultCount = searchResult.results?.count ?? 0
                }
            }
        ).store(in: &searchTokens)

        interactor.fetchNextOffSet(0, searchText: "iPhone")

        XCTAssertGreaterThan(resultCount, 0)
    }
}
