import Combine
import XCTest
@testable import ProductSearch

class HomeRepositoryTests: XCTestCase {
    // MARK: Properties
    
    private var searchTokens = Set<AnyCancellable>()
    
    // MARK: Overridden Functions
    
    override func tearDown() {
        super.tearDown()
        searchTokens.removeAll()
    }
    
    // MARK: Helpers
    
    private func makeRepository(status: TransactionStatus) -> (HomeRepository, HomeCloudDataSourceMock) {
        let cloudDataSourceMock = HomeCloudDataSourceMock(status: status)
        let localDataSourceMock = HomeLocalDataSourceMock()
        let repository = HomeRepository(localDataSource: localDataSourceMock, cloudDataSource: cloudDataSourceMock)
        return (repository, cloudDataSourceMock)
    }
    
    // MARK: - Tests: searchCategory
    
    func testSearchCategoryWithSuccessReturnsResult() {
        // given
        let (repository, _) = makeRepository(status: .success)

        // when / then
        repository.searchCategory(offSet: 0, category: HomeCategorySearch.realState.stringValue)
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
    
    func testSearchCategoryWithSuccessReturnsExpectedCategoryID() {
        // given
        let (repository, _) = makeRepository(status: .success)

        // when / then
        repository.searchCategory(offSet: 0, category: HomeCategorySearch.realState.stringValue)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { searchResult in
                    XCTAssertEqual(
                        searchResult.results?.first?.categoryID,
                        HomeMLCDataMock.homeSearchItem.searchDefaultResult.results?.first?.categoryID
                    )
                }
            )
            .store(in: &searchTokens)
    }
    
    func testSearchCategoryWithFailureReturnsError() {
        // given
        let (repository, _) = makeRepository(status: .failure)

        // when / then
        repository.searchCategory(offSet: 0, category: HomeCategorySearch.realState.stringValue)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTAssertNotNil(error)
                    }
                },
                receiveValue: { _ in
                    XCTFail("Should not return success value on failure")
                }
            )
            .store(in: &searchTokens)
    }
    
    func testSearchCategoryVehiculeWithSuccess() {
        // given
        let (repository, _) = makeRepository(status: .success)

        // when / then
        repository.searchCategory(offSet: 0, category: HomeCategorySearch.vehicule.stringValue)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { searchResult in
                    XCTAssertNotNil(searchResult)
                }
            )
            .store(in: &searchTokens)
    }
    
    func testSearchCategoryServicesWithSuccess() {
        // given
        let (repository, _) = makeRepository(status: .success)

        // when / then
        repository.searchCategory(offSet: 0, category: HomeCategorySearch.services.stringValue)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { searchResult in
                    XCTAssertNotNil(searchResult)
                }
            )
            .store(in: &searchTokens)
    }
    
    // MARK: - Tests: searchItem
    
    func testSearchItemWithSuccessReturnsResult() {
        // given
        let (repository, _) = makeRepository(status: .success)

        // when / then
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
    
    func testSearchItemWithSuccessReturnsExpectedCategoryID() {
        // given
        let (repository, _) = makeRepository(status: .success)

        // when / then
        repository.searchItem(offSet: 0, searchText: "iPhone")
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { searchResult in
                    XCTAssertEqual(
                        searchResult.results?.first?.categoryID,
                        HomeMLCDataMock.homeSearchItem.searchDefaultResult.results?.first?.categoryID
                    )
                }
            )
            .store(in: &searchTokens)
    }
    
    func testSearchItemWithFailureReturnsError() {
        // given
        let (repository, _) = makeRepository(status: .failure)

        // when / then
        repository.searchItem(offSet: 0, searchText: "iPhone")
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTAssertNotNil(error)
                    }
                },
                receiveValue: { _ in
                    XCTFail("Should not return success value on failure")
                }
            )
            .store(in: &searchTokens)
    }
    
    func testSearchItemWithOffset50StillDelegatesToDataSource() {
        // given
        let (repository, cloudDataSourceMock) = makeRepository(status: .success)
        var didReceiveValue = false

        // when
        repository.searchItem(offSet: 50, searchText: "MacBook")
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { _ in
                    didReceiveValue = true
                }
            )
            .store(in: &searchTokens)

        // then
        XCTAssertTrue(didReceiveValue)
        _ = cloudDataSourceMock
    }
    
    func testSearchCategoryWithOffset50StillDelegatesToDataSource() {
        // given
        let (repository, cloudDataSourceMock) = makeRepository(status: .success)
        var didReceiveValue = false

        // when
        repository.searchCategory(offSet: 50, category: HomeCategorySearch.vehicule.stringValue)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { _ in
                    didReceiveValue = true
                }
            )
            .store(in: &searchTokens)

        // then
        XCTAssertTrue(didReceiveValue)
        _ = cloudDataSourceMock
    }
    
    // MARK: - Tests: cloudDataSource error types
    
    func testSearchItemFailureIsHttpError() {
        // given
        let (repository, _) = makeRepository(status: .failure)
        var receivedError: Error?

        // when
        repository.searchItem(offSet: 0, searchText: "Test")
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error
                    }
                },
                receiveValue: { _ in }
            )
            .store(in: &searchTokens)

        // then
        XCTAssertNotNil(receivedError)
        if let cloudError = receivedError as? CloudDataSourceDefaultError,
           case .httpError = cloudError {
            // Expected
        } else {
            XCTFail("Expected httpError, got: \(String(describing: receivedError))")
        }
    }
    
    func testSearchCategoryWithSuccess() {
        // given
        let cloudDataSourceMock = HomeCloudDataSourceMock(status: .success)
        let localDataSourceMock = HomeLocalDataSourceMock()
        let repositoryToTest = HomeRepository(localDataSource: localDataSourceMock, cloudDataSource: cloudDataSourceMock)

        // when / then
        repositoryToTest.searchCategory(offSet: 0, category: HomeCategorySearch.realState.stringValue)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        XCTAssertNil(error, "Result must not retreive error")
                    }
                }, receiveValue: { searchResult in
                    XCTAssertNotNil(searchResult, "Result must not be nil")
                    XCTAssertEqual(searchResult.results?.first?.categoryID, HomeMLCDataMock.homeSearchItem.searchDefaultResult.results?.first?.categoryID)
                }
            ).store(in: &searchTokens)
    }
    
    func testSearchCategoryWithFailure() {
        // given
        let cloudDataSourceMock = HomeCloudDataSourceMock(status: .failure)
        let localDataSourceMock = HomeLocalDataSourceMock()
        let repositoryToTest = HomeRepository(localDataSource: localDataSourceMock, cloudDataSource: cloudDataSourceMock)

        // when / then
        repositoryToTest.searchCategory(offSet: 0, category: HomeCategorySearch.realState.stringValue)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        XCTAssertNotNil(error, "Result must retreive error")
                    }
                }, receiveValue: { _ in
                    XCTAssertTrue(false, "Result must not be successfull")
                }
            ).store(in: &searchTokens)
    }
    
    func testSearchTextWithSuccess() {
        // given
        let cloudDataSourceMock = HomeCloudDataSourceMock(status: .success)
        let localDataSourceMock = HomeLocalDataSourceMock()
        let repositoryToTest = HomeRepository(localDataSource: localDataSourceMock, cloudDataSource: cloudDataSourceMock)

        // when / then
        repositoryToTest.searchItem(offSet: 0, searchText: "iPhone")
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        XCTAssertNil(error, "Result must not retreive error")
                    }
                }, receiveValue: { searchResult in
                    XCTAssertNotNil(searchResult, "Result must not be nil")
                    XCTAssertEqual(searchResult.results?.first?.categoryID, HomeMLCDataMock.homeSearchItem.searchDefaultResult.results?.first?.categoryID)
                }
            ).store(in: &searchTokens)
    }
    
    func testSearchTextWithFailure() {
        // given
        let cloudDataSourceMock = HomeCloudDataSourceMock(status: .failure)
        let localDataSourceMock = HomeLocalDataSourceMock()
        let repositoryToTest = HomeRepository(localDataSource: localDataSourceMock, cloudDataSource: cloudDataSourceMock)

        // when / then
        repositoryToTest.searchItem(offSet: 0, searchText: "iPhone")
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        XCTAssertNotNil(error, "Result must retreive error")
                    }
                }, receiveValue: { _ in
                    XCTAssertTrue(false, "Result must not be successfull")
                }
            ).store(in: &searchTokens)
    }
}
