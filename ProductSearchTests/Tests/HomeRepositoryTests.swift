import Combine
import XCTest
@testable import ArtistSearch

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

    // MARK: - Tests: searchByMedia

    func testSearchByMediaWithSuccessReturnsResult() {
        // given
        let (repository, _) = makeRepository(status: .success)

        // when / then
        repository.searchByMedia(mediaType: HomeCategorySearch.reggaeton.mediaType, searchText: "Reggaeton", limit: 50)
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

    func testSearchByMediaWithSuccessReturnsExpectedArtistName() {
        // given
        let (repository, _) = makeRepository(status: .success)

        // when / then
        repository.searchByMedia(mediaType: HomeCategorySearch.reggaeton.mediaType, searchText: "Reggaeton", limit: 50)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { searchResult in
                    XCTAssertEqual(
                        searchResult.results?.first?.artistName,
                        HomeITunesDataMock.homeSearchArtist.searchDefaultResult.results?.first?.artistName
                    )
                }
            )
            .store(in: &searchTokens)
    }

    func testSearchByMediaWithFailureReturnsError() {
        // given
        let (repository, _) = makeRepository(status: .failure)

        // when / then
        repository.searchByMedia(mediaType: HomeCategorySearch.reggaeton.mediaType, searchText: "Reggaeton", limit: 50)
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

    func testSearchByMediaMoviesWithSuccess() {
        // given
        let (repository, _) = makeRepository(status: .success)

        // when / then
        repository.searchByMedia(mediaType: HomeCategorySearch.salsa.mediaType, searchText: "Salsa", limit: 50)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { searchResult in
                    XCTAssertNotNil(searchResult)
                }
            )
            .store(in: &searchTokens)
    }

    func testSearchByMediaPodcastsWithSuccess() {
        // given
        let (repository, _) = makeRepository(status: .success)

        // when / then
        repository.searchByMedia(mediaType: HomeCategorySearch.rock.mediaType, searchText: "Rock", limit: 50)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { searchResult in
                    XCTAssertNotNil(searchResult)
                }
            )
            .store(in: &searchTokens)
    }

    // MARK: - Tests: searchArtist

    func testSearchArtistWithSuccessReturnsResult() {
        // given
        let (repository, _) = makeRepository(status: .success)

        // when / then
        repository.searchArtist(searchText: "Jack Johnson", limit: 50)
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

    func testSearchArtistWithSuccessReturnsExpectedArtistName() {
        // given
        let (repository, _) = makeRepository(status: .success)

        // when / then
        repository.searchArtist(searchText: "Jack Johnson", limit: 50)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { searchResult in
                    XCTAssertEqual(
                        searchResult.results?.first?.artistName,
                        HomeITunesDataMock.homeSearchArtist.searchDefaultResult.results?.first?.artistName
                    )
                }
            )
            .store(in: &searchTokens)
    }

    func testSearchArtistWithFailureReturnsError() {
        // given
        let (repository, _) = makeRepository(status: .failure)

        // when / then
        repository.searchArtist(searchText: "Jack Johnson", limit: 50)
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

    func testSearchArtistWithLimit50StillDelegatesToDataSource() {
        // given
        let (repository, cloudDataSourceMock) = makeRepository(status: .success)
        var didReceiveValue = false

        // when
        repository.searchArtist(searchText: "Coldplay", limit: 50)
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

    func testSearchByMediaWithLimit50StillDelegatesToDataSource() {
        // given
        let (repository, cloudDataSourceMock) = makeRepository(status: .success)
        var didReceiveValue = false

        // when
        repository.searchByMedia(mediaType: HomeCategorySearch.reggaeton.mediaType, searchText: "Reggaeton", limit: 50)
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

    func testSearchArtistFailureIsHttpError() {
        // given
        let (repository, _) = makeRepository(status: .failure)
        var receivedError: Error?

        // when
        repository.searchArtist(searchText: "Test", limit: 50)
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

    func testSearchByMediaWithSuccess() {
        // given
        let cloudDataSourceMock = HomeCloudDataSourceMock(status: .success)
        let localDataSourceMock = HomeLocalDataSourceMock()
        let repositoryToTest = HomeRepository(localDataSource: localDataSourceMock, cloudDataSource: cloudDataSourceMock)

        // when / then
        repositoryToTest.searchByMedia(mediaType: HomeCategorySearch.reggaeton.mediaType, searchText: "Reggaeton", limit: 50)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        XCTAssertNil(error, "Result must not retrieve error")
                    }
                }, receiveValue: { searchResult in
                    XCTAssertNotNil(searchResult, "Result must not be nil")
                    XCTAssertEqual(
                        searchResult.results?.first?.artistName,
                        HomeITunesDataMock.homeSearchArtist.searchDefaultResult.results?.first?.artistName
                    )
                }
            ).store(in: &searchTokens)
    }

    func testSearchByMediaWithFailure() {
        // given
        let cloudDataSourceMock = HomeCloudDataSourceMock(status: .failure)
        let localDataSourceMock = HomeLocalDataSourceMock()
        let repositoryToTest = HomeRepository(localDataSource: localDataSourceMock, cloudDataSource: cloudDataSourceMock)

        // when / then
        repositoryToTest.searchByMedia(mediaType: HomeCategorySearch.reggaeton.mediaType, searchText: "Reggaeton", limit: 50)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        XCTAssertNotNil(error, "Result must retrieve error")
                    }
                }, receiveValue: { _ in
                    XCTAssertTrue(false, "Result must not be successful")
                }
            ).store(in: &searchTokens)
    }

    func testSearchArtistWithSuccess() {
        // given
        let cloudDataSourceMock = HomeCloudDataSourceMock(status: .success)
        let localDataSourceMock = HomeLocalDataSourceMock()
        let repositoryToTest = HomeRepository(localDataSource: localDataSourceMock, cloudDataSource: cloudDataSourceMock)

        // when / then
        repositoryToTest.searchArtist(searchText: "Jack Johnson", limit: 50)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        XCTAssertNil(error, "Result must not retrieve error")
                    }
                }, receiveValue: { searchResult in
                    XCTAssertNotNil(searchResult, "Result must not be nil")
                    XCTAssertEqual(
                        searchResult.results?.first?.artistName,
                        HomeITunesDataMock.homeSearchArtist.searchDefaultResult.results?.first?.artistName
                    )
                }
            ).store(in: &searchTokens)
    }

    func testSearchArtistWithFailure() {
        // given
        let cloudDataSourceMock = HomeCloudDataSourceMock(status: .failure)
        let localDataSourceMock = HomeLocalDataSourceMock()
        let repositoryToTest = HomeRepository(localDataSource: localDataSourceMock, cloudDataSource: cloudDataSourceMock)

        // when / then
        repositoryToTest.searchArtist(searchText: "Jack Johnson", limit: 50)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        XCTAssertNotNil(error, "Result must retrieve error")
                    }
                }, receiveValue: { _ in
                    XCTAssertTrue(false, "Result must not be successful")
                }
            ).store(in: &searchTokens)
    }
}
