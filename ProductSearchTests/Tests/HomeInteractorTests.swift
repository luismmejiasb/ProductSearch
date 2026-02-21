import Combine
import XCTest
@testable import ArtistSearch

class HomeInteractorTests: XCTestCase {
    // MARK: Properties

    var interactorToTest: HomeInteractorProtocol?
    let searchArtistSelectorName = "searchArtist(searchText:limit:)"
    let searchByMediaSelectorName = "searchByMedia(mediaType:searchText:limit:)"

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
        let interactor = HomeInteractor(repository: repositoryMock, publisher: publisher)
        return (interactor, repositoryMock, publisher)
    }

    func testSearchArtistPassesSearchTextToRepository() {
        // given
        let (interactor, repositoryMock, _) = makeInteractor(status: .success)
        interactorToTest = interactor

        // when
        interactorToTest?.searchArtist(searchText: "Jack Johnson")

        // then
        XCTAssertEqual(repositoryMock.lastSearchText, "Jack Johnson")
    }

    // MARK: - Tests: searchByCategory

    func testSearchByCategoryReggaetonWithSuccess() {
        // given
        let (interactor, repositoryMock, publisher) = makeInteractor(status: .success)
        interactorToTest = interactor

        publisher.sink(
            receiveCompletion: { completion in
                if case .failure = completion { XCTFail("Should not fail") }
            },
            receiveValue: { result in
                switch result {
                case .categorySearchedWithSuccess(let searchResult, let searchedCategory):
                    XCTAssertNotNil(searchResult)
                    XCTAssertEqual(searchedCategory, .reggaeton)
                default:
                    XCTFail("Expected category success, got: \(result)")
                }
            }
        ).store(in: &searchTokens)

        // when
        interactorToTest?.searchByCategory(.reggaeton)

        XCTAssertEqual(repositoryMock.functionsCalled.count, 1)
        XCTAssertEqual(repositoryMock.functionsCalled[0], searchByMediaSelectorName)
    }

    func testSearchByCategorySalsaWithSuccess() {
        // given
        let (interactor, repositoryMock, publisher) = makeInteractor(status: .success)
        interactorToTest = interactor

        publisher.sink(
            receiveCompletion: { _ in },
            receiveValue: { result in
                switch result {
                case .categorySearchedWithSuccess(_, let searchedCategory):
                    XCTAssertEqual(searchedCategory, .salsa)
                default:
                    XCTFail("Expected salsa category success")
                }
            }
        ).store(in: &searchTokens)

        // when
        interactorToTest?.searchByCategory(.salsa)

        XCTAssertEqual(repositoryMock.functionsCalled.count, 1)
        XCTAssertEqual(repositoryMock.lastMediaType, HomeCategorySearch.salsa.mediaType)
    }

    func testSearchByCategoryRockWithSuccess() {
        // given
        let (interactor, repositoryMock, publisher) = makeInteractor(status: .success)
        interactorToTest = interactor

        publisher.sink(
            receiveCompletion: { _ in },
            receiveValue: { result in
                switch result {
                case .categorySearchedWithSuccess(_, let searchedCategory):
                    XCTAssertEqual(searchedCategory, .rock)
                default:
                    XCTFail("Expected rock category success")
                }
            }
        ).store(in: &searchTokens)

        // when
        interactorToTest?.searchByCategory(.rock)

        XCTAssertEqual(repositoryMock.functionsCalled.count, 1)
        XCTAssertEqual(repositoryMock.lastMediaType, HomeCategorySearch.rock.mediaType)
    }

    func testSearchByCategoryPassesCorrectMediaTypeToRepository() {
        // given — all music genres pass "music", .none passes ""
        let categories: [(HomeCategorySearch, String)] = [
            (.reggaeton, "music"),
            (.salsa, "music"),
            (.pop, "music"),
            (.rock, "music"),
            (.jazz, "music"),
            (.none, "")
        ]

        for (category, expectedMediaType) in categories {
            let (interactor, repositoryMock, _) = makeInteractor(status: .success)
            interactor.searchByCategory(category)

            XCTAssertEqual(
                repositoryMock.lastMediaType,
                expectedMediaType,
                "Category \(category) should pass '\(expectedMediaType)' to repository"
            )
        }
    }

    // MARK: - Tests: publisher without subscribers

    func testSearchArtistWithNoSubscribersDoesNotCrash() {
        // given
        let (interactor, repositoryMock, _) = makeInteractor(status: .success)

        // when
        interactor.searchArtist(searchText: "Jack Johnson")

        // then
        XCTAssertEqual(repositoryMock.functionsCalled.count, 1)
    }

    func testSearchByCategoryWithNoSubscribersDoesNotCrash() {
        // given
        let (interactor, repositoryMock, _) = makeInteractor(status: .success)

        // when
        interactor.searchByCategory(.reggaeton)

        // then
        XCTAssertEqual(repositoryMock.functionsCalled.count, 1)
    }

    func testSearchArtistWithSuccess() {
        // given
        let status: TransactionStatus = .success
        let cloudDataSourceMock = HomeCloudDataSourceMock(status: status)
        let localDataSourceMock = HomeLocalDataSourceMock()
        let repositoryMock = HomeRepositoryMock(status: status, localDataSource: localDataSourceMock, cloudDataSource: cloudDataSourceMock)
        let publisher = PassthroughSubject<HomePublisherResult, Error>()
        interactorToTest = HomeInteractor(repository: repositoryMock, publisher: publisher)

        publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    XCTAssertTrue(false, "Publisher should not publish error when completing observing")
                }
            }, receiveValue: { result in
                switch result {
                case .itemsSearchedWithSuccess(let searchResult):
                    XCTAssertNotNil(searchResult)
                case .itemsSearchedWithFailure:
                    XCTAssertTrue(false, "Item searched must be successful")
                case .categorySearchedWithSuccess:
                    XCTAssertTrue(false, "categorySearchedWithSuccess should not be called")
                case .categorySearchedWithFailure:
                    XCTAssertTrue(false, "categorySearchedWithFailure should not be called")
                }
            }
        ).store(in: &searchTokens)

        // when
        interactorToTest?.searchArtist(searchText: "Jack Johnson")

        let expectedRepositoryFunctionsCalled = 1
        if repositoryMock.functionsCalled.count == expectedRepositoryFunctionsCalled {
            XCTAssertEqual(repositoryMock.functionsCalled[0], searchArtistSelectorName)
        } else {
            XCTFail("Missing Functions Called. Expected \(expectedRepositoryFunctionsCalled) but called \(repositoryMock.functionsCalled.count)")
        }
    }

    func testSearchArtistWithFailure() {
        // given
        let status: TransactionStatus = .failure
        let cloudDataSourceMock = HomeCloudDataSourceMock(status: status)
        let localDataSourceMock = HomeLocalDataSourceMock()
        let repositoryMock = HomeRepositoryMock(status: status, localDataSource: localDataSourceMock, cloudDataSource: cloudDataSourceMock)
        let publisher = PassthroughSubject<HomePublisherResult, Error>()
        interactorToTest = HomeInteractor(repository: repositoryMock, publisher: publisher)

        publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTAssertNotNil(error, "Publisher should retrieve error when completing observing")
                }
            }, receiveValue: { result in
                switch result {
                case .itemsSearchedWithSuccess:
                    XCTAssertTrue(false, "Item searched must not be successful")
                case .itemsSearchedWithFailure(let error):
                    XCTAssertNotNil(error, "Publisher should retrieve error receiving value")
                case .categorySearchedWithSuccess:
                    XCTAssertTrue(false, "categorySearchedWithSuccess should not be called")
                case .categorySearchedWithFailure:
                    XCTAssertTrue(false, "categorySearchedWithFailure should not be called")
                }
            }
        ).store(in: &searchTokens)

        // when
        interactorToTest?.searchArtist(searchText: "Jack Johnson")

        let expectedRepositoryFunctionsCalled = 1
        if repositoryMock.functionsCalled.count == expectedRepositoryFunctionsCalled {
            XCTAssertEqual(repositoryMock.functionsCalled[0], searchArtistSelectorName)
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
        interactorToTest = HomeInteractor(repository: repositoryMock, publisher: publisher)

        publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    XCTAssertTrue(false, "Publisher should not publish error when completing observing")
                }
            }, receiveValue: { result in
                switch result {
                case .itemsSearchedWithSuccess:
                    XCTAssertTrue(false, "itemsSearchedWithSuccess should not be called")
                case .itemsSearchedWithFailure:
                    XCTAssertTrue(false, "itemsSearchedWithFailure should not be called")
                case .categorySearchedWithSuccess(let searchResult, let searchedCategory):
                    XCTAssertNotNil(searchResult)
                    XCTAssertEqual(searchedCategory, .reggaeton)
                case .categorySearchedWithFailure:
                    XCTAssertTrue(false, "Item searched must be successful")
                }
            }
        ).store(in: &searchTokens)

        // when
        interactorToTest?.searchByCategory(.reggaeton)

        let expectedRepositoryFunctionsCalled = 1
        if repositoryMock.functionsCalled.count == expectedRepositoryFunctionsCalled {
            XCTAssertEqual(repositoryMock.functionsCalled[0], searchByMediaSelectorName)
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
        interactorToTest = HomeInteractor(repository: repositoryMock, publisher: publisher)

        publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTAssertNotNil(error, "Publisher should retrieve error when completing observing")
                }
            }, receiveValue: { result in
                switch result {
                case .itemsSearchedWithSuccess:
                    XCTAssertTrue(false, "itemsSearchedWithSuccess should not be called")
                case .itemsSearchedWithFailure:
                    XCTAssertTrue(false, "itemsSearchedWithFailure should not be called")
                case .categorySearchedWithSuccess:
                    XCTAssertTrue(false, "Category searched result should not be successful")
                case .categorySearchedWithFailure(let error):
                    XCTAssertNotNil(error, "Publisher should retrieve error receiving value")
                }
            }
        ).store(in: &searchTokens)

        // when
        interactorToTest?.searchByCategory(.reggaeton)

        let expectedRepositoryFunctionsCalled = 1
        if repositoryMock.functionsCalled.count == expectedRepositoryFunctionsCalled {
            XCTAssertEqual(repositoryMock.functionsCalled[0], searchByMediaSelectorName)
        } else {
            XCTFail("Missing Functions Called. Expected \(expectedRepositoryFunctionsCalled) but called \(repositoryMock.functionsCalled.count)")
        }
    }
}
