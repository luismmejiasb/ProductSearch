import Combine
import XCTest
@testable import ProductSearch

class HomeRepositoryTests: XCTestCase {
    // MARK: Properties

    private var searchTokens = Set<AnyCancellable>()

    // MARK: Functions

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
                    XCTAssertEqual(searchResult.results![0].categoryID, HomeMLCDataMock.homeSearchItem.searchDefaultResult?.results![0].categoryID)
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
                    XCTAssertEqual(searchResult.results![0].categoryID, HomeMLCDataMock.homeSearchItem.searchDefaultResult?.results![0].categoryID)
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
