import Combine
import XCTest
@testable import ProductSearch

// MARK: - SearchResultRepositoryTests

class SearchResultRepositoryTests: XCTestCase {
    // MARK: Properties

    private var searchTokens = Set<AnyCancellable>()

    // MARK: Overridden Functions

    override func tearDown() {
        super.tearDown()
        searchTokens.removeAll()
    }

    // MARK: Helpers

    private func makeRepository(
        status: TransactionStatus,
        mockData: SearchResultMLCDataMock = .multipleResults
    ) -> (SearchResultRepository, SearchResultCloudDataSourceMock) {
        let cloudDataSourceMock = SearchResultCloudDataSourceMock(status: status, mockData: mockData)
        let localDataSourceMock = SearchResultLocalDataSourceMock()
        let repository = SearchResultRepository(
            localDataSource: localDataSourceMock,
            cloudDataSource: cloudDataSourceMock
        )
        return (repository, cloudDataSourceMock)
    }

    // MARK: - Tests: searchItem

    func testSearchItem_withSuccess_returnsResult() {
        let (repository, _) = makeRepository(status: .success)

        repository.searchItem(offSet: 0, searchText: "iPhone")
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTFail("Should not fail: \(error)")
                    }
                },
                receiveValue: { searchResult in
                    XCTAssertNotNil(searchResult)
                    XCTAssertNotNil(searchResult.results)
                }
            )
            .store(in: &searchTokens)
    }

    func testSearchItem_withSuccess_returnsExpectedResults() {
        let (repository, _) = makeRepository(status: .success, mockData: .multipleResults)

        repository.searchItem(offSet: 0, searchText: "iPhone")
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { searchResult in
                    XCTAssertEqual(searchResult.results?.count, 3)
                    XCTAssertEqual(searchResult.results?.first?.title, "iPhone 13 128GB")
                }
            )
            .store(in: &searchTokens)
    }

    func testSearchItem_withFailure_publishesError() {
        let (repository, _) = makeRepository(status: .failure)

        repository.searchItem(offSet: 0, searchText: "iPhone")
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTAssertNotNil(error)
                    }
                },
                receiveValue: { _ in
                    XCTFail("Should not succeed on failure status")
                }
            )
            .store(in: &searchTokens)
    }

    func testSearchItem_withOffset50_delegates() {
        let (repository, _) = makeRepository(status: .success)
        var didReceive = false

        repository.searchItem(offSet: 50, searchText: "MacBook")
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { _ in didReceive = true }
            )
            .store(in: &searchTokens)

        XCTAssertTrue(didReceive)
    }

    // MARK: - Tests: searchCategory

    func testSearchCategory_withSuccess_returnsResult() {
        let (repository, _) = makeRepository(status: .success, mockData: .categoryResults)

        repository.searchCategory(offSet: 0, category: HomeCategorySearch.vehicule.stringValue)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTFail("Should not fail: \(error)")
                    }
                },
                receiveValue: { searchResult in
                    XCTAssertNotNil(searchResult)
                    XCTAssertNotNil(searchResult.results)
                }
            )
            .store(in: &searchTokens)
    }

    func testSearchCategory_vehicule_returnsResultsWithCorrectCategoryID() {
        let (repository, _) = makeRepository(status: .success, mockData: .categoryResults)

        repository.searchCategory(offSet: 0, category: HomeCategorySearch.vehicule.stringValue)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { searchResult in
                    XCTAssertEqual(searchResult.results?.first?.categoryID, "MLC1743")
                }
            )
            .store(in: &searchTokens)
    }

    func testSearchCategory_withFailure_publishesError() {
        let (repository, _) = makeRepository(status: .failure)

        repository.searchCategory(offSet: 0, category: HomeCategorySearch.realState.stringValue)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTAssertNotNil(error)
                    }
                },
                receiveValue: { _ in
                    XCTFail("Should not succeed on failure status")
                }
            )
            .store(in: &searchTokens)
    }

    func testSearchCategory_withOffset100_delegates() {
        let (repository, _) = makeRepository(status: .success)
        var didReceive = false

        repository.searchCategory(offSet: 100, category: HomeCategorySearch.services.stringValue)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { _ in didReceive = true }
            )
            .store(in: &searchTokens)

        XCTAssertTrue(didReceive)
    }

    // MARK: - Tests: nil cloudDataSource returns unwrappableValue error

    func testSearchItem_withNilCloudDataSource_returnsUnwrappableError() {
        let localDataSourceMock = SearchResultLocalDataSourceMock()
        let repository = SearchResultRepository(localDataSource: localDataSourceMock, cloudDataSource: nil)
        var receivedError: Error?

        repository.searchItem(offSet: 0, searchText: "test")
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error
                    }
                },
                receiveValue: { _ in XCTFail("Should fail with nil cloud data source") }
            )
            .store(in: &searchTokens)

        XCTAssertNotNil(receivedError)
        if let cloudError = receivedError as? CloudDataSourceDefaultError,
           case .unwrappableValue = cloudError {
            // Expected
        } else {
            XCTFail("Expected unwrappableValue error, got: \(String(describing: receivedError))")
        }
    }

    func testSearchCategory_withNilCloudDataSource_returnsUnwrappableError() {
        let localDataSourceMock = SearchResultLocalDataSourceMock()
        let repository = SearchResultRepository(localDataSource: localDataSourceMock, cloudDataSource: nil)
        var receivedError: Error?

        repository.searchCategory(offSet: 0, category: "MLC1743")
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error
                    }
                },
                receiveValue: { _ in XCTFail("Should fail with nil cloud data source") }
            )
            .store(in: &searchTokens)

        XCTAssertNotNil(receivedError)
        if let cloudError = receivedError as? CloudDataSourceDefaultError,
           case .unwrappableValue = cloudError {
            // Expected
        } else {
            XCTFail("Expected unwrappableValue error, got: \(String(describing: receivedError))")
        }
    }

    // MARK: - Tests: empty results

    func testSearchItem_withEmptyResults_returnsEmptyResultsArray() {
        let (repository, _) = makeRepository(status: .success, mockData: .emptyResults)

        repository.searchItem(offSet: 0, searchText: "qwerty12345xyz")
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { searchResult in
                    XCTAssertEqual(searchResult.results?.count, 0)
                    XCTAssertEqual(searchResult.paging?.total, 0)
                }
            )
            .store(in: &searchTokens)
    }
}
