import Combine
import XCTest
@testable import ProductSearch

class HomeInteractorTests: XCTestCase {
    // MARK: Properties

    var interactorToTest: HomeInteractorProtocol?
    let searchItemSelectorName = "searchItem(offSet:searchText:)"
    let searchCategorySelectorName = "searchCategory(offSet:category:)"

    private var searchTokens = Set<AnyCancellable>()

    // MARK: Overridden Functions

    override func tearDown() {
        super.tearDown()
        interactorToTest = nil
        searchTokens.removeAll()
    }

    // MARK: Helpers

    private func makeInteractor(status: TransactionStatus) -> (HomeInteractor, HomeRepositoryMock, PassthroughSubject<HomePublisherResult, Error>) {
        let cloudDataSourceMock = HomeCloudDataSourceMock(status: status)
        let localDataSourceMock = HomeLocalDataSourceMock()
        let repositoryMock = HomeRepositoryMock(status: status, localDataSource: localDataSourceMock, cloudDataSource: cloudDataSourceMock)
        let publisher = PassthroughSubject<HomePublisherResult, Error>()
        let interactor = HomeInteractor(repository: repositoryMock)
        interactor.publisher = publisher
        return (interactor, repositoryMock, publisher)
    }
    
    func testSearchItemPassesSearchTextToRepository() {
        // given
        let (interactor, repositoryMock, _) = makeInteractor(status: .success)
        interactorToTest = interactor

        // when
        interactorToTest?.serachItem(searchText: "MacBook")

        // then
        XCTAssertEqual(repositoryMock.lastSearchText, "MacBook")
    }

    func testSearchItemUsesZeroOffset() {
        // given
        let (interactor, repositoryMock, _) = makeInteractor(status: .success)
        interactorToTest = interactor

        // when
        interactorToTest?.serachItem(searchText: "iPad")

        // then
        XCTAssertEqual(repositoryMock.lastOffSet, 0)
    }

    // MARK: - Tests: searchByCategory

    func testSearchByCategoryRealStateWithSuccess() {
        // given
        let (interactor, repositoryMock, publisher) = makeInteractor(status: .success)
        interactorToTest = interactor

        publisher.sink(
            receiveCompletion: { completion in
                if case .failure = completion { XCTFail("Should not fail") }
            },
            receiveValue: { result in
                // then
                switch result {
                case .categorySearchedWithSuccess(let searchResult, let searchedCategory):
                    XCTAssertNotNil(searchResult)
                    XCTAssertEqual(searchedCategory, .realState)
                default:
                    XCTFail("Expected category success, got: \(result)")
                }
            }
        ).store(in: &searchTokens)

        // when
        interactorToTest?.searchByCategory(.realState)

        XCTAssertEqual(repositoryMock.functionsCalled.count, 1)
        XCTAssertEqual(repositoryMock.functionsCalled[0], searchCategorySelectorName)
    }

    func testSearchByCategoryVehiculeWithSuccess() {
        // given
        let (interactor, repositoryMock, publisher) = makeInteractor(status: .success)
        interactorToTest = interactor

        publisher.sink(
            receiveCompletion: { _ in },
            receiveValue: { result in
                // then
                switch result {
                case .categorySearchedWithSuccess(_, let searchedCategory):
                    XCTAssertEqual(searchedCategory, .vehicule)
                default:
                    XCTFail("Expected vehicule category success")
                }
            }
        ).store(in: &searchTokens)

        // when
        interactorToTest?.searchByCategory(.vehicule)

        XCTAssertEqual(repositoryMock.functionsCalled.count, 1)
        XCTAssertEqual(repositoryMock.lastCategory, HomeCategorySearch.vehicule.stringValue)
    }

    func testSearchByCategoryServicesWithSuccess() {
        // given
        let (interactor, repositoryMock, publisher) = makeInteractor(status: .success)
        interactorToTest = interactor

        publisher.sink(
            receiveCompletion: { _ in },
            receiveValue: { result in
                // then
                switch result {
                case .categorySearchedWithSuccess(_, let searchedCategory):
                    XCTAssertEqual(searchedCategory, .services)
                default:
                    XCTFail("Expected services category success")
                }
            }
        ).store(in: &searchTokens)

        // when
        interactorToTest?.searchByCategory(.services)

        XCTAssertEqual(repositoryMock.functionsCalled.count, 1)
        XCTAssertEqual(repositoryMock.lastCategory, HomeCategorySearch.services.stringValue)
    }

    func testSearchByCategoryPassesCorrectStringToRepository() {
        // given
        let categories: [(HomeCategorySearch, String)] = [
            (.vehicule, "MLC1743"),
            (.realState, "MLC1459"),
            (.services, "MLC1540"),
            (.none, "")
        ]

        for (category, expectedString) in categories {
            // when
            let (interactor, repositoryMock, _) = makeInteractor(status: .success)
            interactor.searchByCategory(category)

            // then
            XCTAssertEqual(
                repositoryMock.lastCategory,
                expectedString,
                "Category \(category) should pass '\(expectedString)' to repository"
            )
        }
    }

    // MARK: - Tests: publisher nil does not crash

    func testSearchItemWithNilPublisherDoesNotCrash() {
        // given
        let cloudDataSourceMock = HomeCloudDataSourceMock(status: .success)
        let localDataSourceMock = HomeLocalDataSourceMock()
        let repositoryMock = HomeRepositoryMock(status: .success, localDataSource: localDataSourceMock, cloudDataSource: cloudDataSourceMock)
        let interactor = HomeInteractor(repository: repositoryMock)
        interactor.publisher = nil

        // when
        interactor.serachItem(searchText: "iPhone")

        // then
        XCTAssertEqual(repositoryMock.functionsCalled.count, 1)
    }

    func testSearchByCategoryWithNilPublisherDoesNotCrash() {
        // given
        let cloudDataSourceMock = HomeCloudDataSourceMock(status: .success)
        let localDataSourceMock = HomeLocalDataSourceMock()
        let repositoryMock = HomeRepositoryMock(status: .success, localDataSource: localDataSourceMock, cloudDataSource: cloudDataSourceMock)
        let interactor = HomeInteractor(repository: repositoryMock)
        interactor.publisher = nil

        // when
        interactor.searchByCategory(.vehicule)

        // then
        XCTAssertEqual(repositoryMock.functionsCalled.count, 1)
    }

    func testSearchItemWithSuccess() {
        // given
        let status: TransactionStatus = .success
        let cloudDataSourceMock = HomeCloudDataSourceMock(status: status)
        let localDataSourceMock = HomeLocalDataSourceMock()
        let repositoryMock = HomeRepositoryMock(status: status, localDataSource: localDataSourceMock, cloudDataSource: cloudDataSourceMock)
        let publisher = PassthroughSubject<HomePublisherResult, Error>()
        interactorToTest = HomeInteractor(repository: repositoryMock)
        interactorToTest?.publisher = publisher

        interactorToTest?.publisher?.sink(
            receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    XCTAssertTrue(false, "Publisher should not publish error when completiting observing")
                }
            }, receiveValue: { result in
                // then
                switch result {
                case .itemsSearchedWithSuccess(let searchResult):
                    XCTAssertNotNil(searchResult)
                case .itemsSearchedWithFailure:
                    XCTAssertTrue(false, "Item searched must be successfull")
                case .categorySearchedWithSuccess:
                    XCTAssertTrue(false, "categorySearchedWithSuccess should not be called")
                case .categorySearchedWithFailure:
                    XCTAssertTrue(false, "categorySearchedWithFailure should not be called")
                }
            }
        ).store(in: &searchTokens)

        // when
        interactorToTest?.serachItem(searchText: "iPhone")

        let expectedRepositoryFunctionsCalled = 1
        if repositoryMock.functionsCalled.count == expectedRepositoryFunctionsCalled {
            XCTAssertEqual(repositoryMock.functionsCalled[0], searchItemSelectorName)
        } else {
            XCTFail("Missing Functions Called. Expected \(expectedRepositoryFunctionsCalled) but called \(repositoryMock.functionsCalled.count)")
        }
    }

    func testSearchItemWithFailure() {
        // given
        let status: TransactionStatus = .failure
        let cloudDataSourceMock = HomeCloudDataSourceMock(status: status)
        let localDataSourceMock = HomeLocalDataSourceMock()
        let repositoryMock = HomeRepositoryMock(status: status, localDataSource: localDataSourceMock, cloudDataSource: cloudDataSourceMock)
        let publisher = PassthroughSubject<HomePublisherResult, Error>()
        interactorToTest = HomeInteractor(repository: repositoryMock)
        interactorToTest?.publisher = publisher

        interactorToTest?.publisher?.sink(
            receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTAssertNotNil(error, "Publisher should retreive error when completiting observing")
                }
            }, receiveValue: { result in
                // then
                switch result {
                case .itemsSearchedWithSuccess:
                    XCTAssertTrue(false, "Item searched must not be successfull")
                case .itemsSearchedWithFailure(let error):
                    XCTAssertNotNil(error, "Publisher should retreive error receiving value")
                case .categorySearchedWithSuccess:
                    XCTAssertTrue(false, "categorySearchedWithSuccess should not be called")
                case .categorySearchedWithFailure:
                    XCTAssertTrue(false, "categorySearchedWithFailure should not be called")
                }
            }
        ).store(in: &searchTokens)

        // when
        interactorToTest?.serachItem(searchText: "iPhone")

        let expectedRepositoryFunctionsCalled = 1
        if repositoryMock.functionsCalled.count == expectedRepositoryFunctionsCalled {
            XCTAssertEqual(repositoryMock.functionsCalled[0], searchItemSelectorName)
        } else {
            XCTFail("Missing Functions Called. Expected \(expectedRepositoryFunctionsCalled) but called \(repositoryMock.functionsCalled.count)")
        }
    }

    func testSearchByCategoryWithSuccess() {
        // given
        let status: TransactionStatus = .success
        let cloudDataSourceMock = HomeCloudDataSourceMock(status: status)
        let localDataSourceMock = HomeLocalDataSourceMock()
        let repositoryMock = HomeRepositoryMock(status: status, localDataSource: localDataSourceMock, cloudDataSource: cloudDataSourceMock)
        let publisher = PassthroughSubject<HomePublisherResult, Error>()
        interactorToTest = HomeInteractor(repository: repositoryMock)
        interactorToTest?.publisher = publisher

        interactorToTest?.publisher?.sink(
            receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    XCTAssertTrue(false, "Publisher should not publish error when completiting observing")
                }
            }, receiveValue: { result in
                // then
                switch result {
                case .itemsSearchedWithSuccess:
                    XCTAssertTrue(false, "itemsSearchedWithSuccess should not be called")
                case .itemsSearchedWithFailure:
                    XCTAssertTrue(false, "itemsSearchedWithSuccess should not be called")
                case .categorySearchedWithSuccess(let searchResult, let searchedCategory):
                    XCTAssertNotNil(searchResult)
                    XCTAssertEqual(searchedCategory, .realState)
                case .categorySearchedWithFailure:
                    XCTAssertTrue(false, "Item searched must be successfull")
                }
            }
        ).store(in: &searchTokens)

        // when
        interactorToTest?.searchByCategory(.realState)

        let expectedRepositoryFunctionsCalled = 1
        if repositoryMock.functionsCalled.count == expectedRepositoryFunctionsCalled {
            XCTAssertEqual(repositoryMock.functionsCalled[0], searchCategorySelectorName)
        } else {
            XCTFail("Missing Functions Called. Expected \(expectedRepositoryFunctionsCalled) but called \(repositoryMock.functionsCalled.count)")
        }
    }

    func testSearchByCategoryWithFailure() {
        // given
        let status: TransactionStatus = .failure
        let cloudDataSourceMock = HomeCloudDataSourceMock(status: status)
        let localDataSourceMock = HomeLocalDataSourceMock()
        let repositoryMock = HomeRepositoryMock(status: status, localDataSource: localDataSourceMock, cloudDataSource: cloudDataSourceMock)
        let publisher = PassthroughSubject<HomePublisherResult, Error>()
        interactorToTest = HomeInteractor(repository: repositoryMock)
        interactorToTest?.publisher = publisher

        interactorToTest?.publisher?.sink(
            receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTAssertNotNil(error, "Publisher should retreive error when completiting observing")
                }
            }, receiveValue: { result in
                // then
                switch result {
                case .itemsSearchedWithSuccess:
                    XCTAssertTrue(false, "itemsSearchedWithSuccess should not be called")
                case .itemsSearchedWithFailure:
                    XCTAssertTrue(false, "itemsSearchedWithSuccess should not be called")
                case .categorySearchedWithSuccess:
                    XCTAssertTrue(false, "Category searched result should not be successfull")
                case .categorySearchedWithFailure(let error):
                    XCTAssertNotNil(error, "Publisher should retreive error receiving value")
                }
            }
        ).store(in: &searchTokens)

        // when
        interactorToTest?.searchByCategory(.realState)

        let expectedRepositoryFunctionsCalled = 1
        if repositoryMock.functionsCalled.count == expectedRepositoryFunctionsCalled {
            XCTAssertEqual(repositoryMock.functionsCalled[0], searchCategorySelectorName)
        } else {
            XCTFail("Missing Functions Called. Expected \(expectedRepositoryFunctionsCalled) but called \(repositoryMock.functionsCalled.count)")
        }
    }
}
