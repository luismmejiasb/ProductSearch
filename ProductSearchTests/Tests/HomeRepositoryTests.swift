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
    
    func testSearchCategory_withSuccess_returnsResult() {
        let (repository, _) = makeRepository(status: .success)
        
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
    
    func testSearchCategory_withSuccess_returnsExpectedCategoryID() {
        let (repository, _) = makeRepository(status: .success)
        
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
    
    func testSearchCategory_withFailure_returnsError() {
        let (repository, _) = makeRepository(status: .failure)
        
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
    
    func testSearchCategory_vehicule_withSuccess() {
        let (repository, _) = makeRepository(status: .success)
        
        repository.searchCategory(offSet: 0, category: HomeCategorySearch.vehicule.stringValue)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { searchResult in
                    XCTAssertNotNil(searchResult)
                }
            )
            .store(in: &searchTokens)
    }
    
    func testSearchCategory_services_withSuccess() {
        let (repository, _) = makeRepository(status: .success)
        
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
    
    func testSearchItem_withSuccess_returnsExpectedCategoryID() {
        let (repository, _) = makeRepository(status: .success)
        
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
    
    func testSearchItem_withFailure_returnsError() {
        let (repository, _) = makeRepository(status: .failure)
        
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
    
    func testSearchItem_withOffset50_stillDelegatesToDataSource() {
        let (repository, cloudDataSourceMock) = makeRepository(status: .success)
        var didReceiveValue = false
        
        repository.searchItem(offSet: 50, searchText: "MacBook")
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { _ in
                    didReceiveValue = true
                }
            )
            .store(in: &searchTokens)
        
        XCTAssertTrue(didReceiveValue)
        _ = cloudDataSourceMock
    }
    
    func testSearchCategory_withOffset50_stillDelegatesToDataSource() {
        let (repository, cloudDataSourceMock) = makeRepository(status: .success)
        var didReceiveValue = false
        
        repository.searchCategory(offSet: 50, category: HomeCategorySearch.vehicule.stringValue)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { _ in
                    didReceiveValue = true
                }
            )
            .store(in: &searchTokens)
        
        XCTAssertTrue(didReceiveValue)
        _ = cloudDataSourceMock
    }
    
    // MARK: - Tests: cloudDataSource error types
    
    func testSearchItem_failure_isHttpError() {
        let (repository, _) = makeRepository(status: .failure)
        var receivedError: Error?
        
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
        
        XCTAssertNotNil(receivedError)
        if let cloudError = receivedError as? CloudDataSourceDefaultError,
           case .httpError = cloudError {
            // Expected
        } else {
            XCTFail("Expected httpError, got: \(String(describing: receivedError))")
        }
    }
    
    func testSearchCategoryWithSuccess() {
        let cloudDataSourceMock = HomeCloudDataSourceMock(status: .success)
        let localDataSourceMock = HomeLocalDataSourceMock()
        
        let repositoryToTest = HomeRepository(localDataSource: localDataSourceMock, cloudDataSource: cloudDataSourceMock)
        
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
        let cloudDataSourceMock = HomeCloudDataSourceMock(status: .failure)
        let localDataSourceMock = HomeLocalDataSourceMock()
        
        let repositoryToTest = HomeRepository(localDataSource: localDataSourceMock, cloudDataSource: cloudDataSourceMock)
        
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
        let cloudDataSourceMock = HomeCloudDataSourceMock(status: .success)
        let localDataSourceMock = HomeLocalDataSourceMock()
        
        let repositoryToTest = HomeRepository(localDataSource: localDataSourceMock, cloudDataSource: cloudDataSourceMock)
        
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
        let cloudDataSourceMock = HomeCloudDataSourceMock(status: .failure)
        let localDataSourceMock = HomeLocalDataSourceMock()
        
        let repositoryToTest = HomeRepository(localDataSource: localDataSourceMock, cloudDataSource: cloudDataSourceMock)
        
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
