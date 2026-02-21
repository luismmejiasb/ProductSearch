import Combine
import XCTest
@testable import ArtistSearch

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
        mockData: SearchResultITunesDataMock = .multipleResults
    ) -> (SearchResultRepository, SearchResultCloudDataSourceMock) {
        let cloudDataSourceMock = SearchResultCloudDataSourceMock(status: status, mockData: mockData)
        let localDataSourceMock = SearchResultLocalDataSourceMock()
        let repository = SearchResultRepository(
            localDataSource: localDataSourceMock,
            cloudDataSource: cloudDataSourceMock
        )
        return (repository, cloudDataSourceMock)
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

    func testSearchArtistWithSuccessReturnsExpectedResults() {
        // given
        let (repository, _) = makeRepository(status: .success, mockData: .multipleResults)

        // when / then
        repository.searchArtist(searchText: "Jack Johnson", limit: 50)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { searchResult in
                    XCTAssertEqual(searchResult.results?.count, 3)
                    XCTAssertEqual(searchResult.results?.first?.artistName, "Jack Johnson")
                }
            )
            .store(in: &searchTokens)
    }

    func testSearchArtistWithFailurePublishesError() {
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
                    XCTFail("Should not succeed on failure status")
                }
            )
            .store(in: &searchTokens)
    }

    func testSearchArtistWithLimit50Delegates() {
        // given
        let (repository, _) = makeRepository(status: .success)
        var didReceive = false

        // when
        repository.searchArtist(searchText: "Coldplay", limit: 50)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { _ in didReceive = true }
            )
            .store(in: &searchTokens)

        // then
        XCTAssertTrue(didReceive)
    }

    // MARK: - Tests: searchByMedia

    func testSearchByMediaWithSuccessReturnsResult() {
        // given
        let (repository, _) = makeRepository(status: .success, mockData: .multipleResults)

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

    func testSearchByMediaMusicReturnsResultsWithArtistName() {
        // given
        let (repository, _) = makeRepository(status: .success, mockData: .multipleResults)

        // when / then
        repository.searchByMedia(mediaType: HomeCategorySearch.reggaeton.mediaType, searchText: "Reggaeton", limit: 50)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { searchResult in
                    XCTAssertEqual(searchResult.results?.first?.artistName, "Jack Johnson")
                    XCTAssertEqual(searchResult.results?.first?.primaryGenreName, "Rock")
                }
            )
            .store(in: &searchTokens)
    }

    func testSearchByMediaWithFailurePublishesError() {
        // given
        let (repository, _) = makeRepository(status: .failure)

        // when / then
        repository.searchByMedia(mediaType: HomeCategorySearch.salsa.mediaType, searchText: "Salsa", limit: 50)
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

    func testSearchByMediaWithLimit100Delegates() {
        // given
        let (repository, _) = makeRepository(status: .success)
        var didReceive = false

        // when
        repository.searchByMedia(mediaType: HomeCategorySearch.rock.mediaType, searchText: "Rock", limit: 100)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { _ in didReceive = true }
            )
            .store(in: &searchTokens)

        // then
        XCTAssertTrue(didReceive)
    }

    // MARK: - Tests: nil cloudDataSource returns unwrappableValue error

    func testSearchArtistWithNilCloudDataSourceReturnsUnwrappableError() {
        // given
        let localDataSourceMock = SearchResultLocalDataSourceMock()
        let repository = SearchResultRepository(localDataSource: localDataSourceMock, cloudDataSource: nil)
        var receivedError: Error?

        // when
        repository.searchArtist(searchText: "test", limit: 50)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error
                    }
                },
                receiveValue: { _ in XCTFail("Should fail with nil cloud data source") }
            )
            .store(in: &searchTokens)

        // then
        XCTAssertNotNil(receivedError)
        if let cloudError = receivedError as? CloudDataSourceDefaultError,
           case .unwrappableValue = cloudError {
            // Expected
        } else {
            XCTFail("Expected unwrappableValue error, got: \(String(describing: receivedError))")
        }
    }

    func testSearchByMediaWithNilCloudDataSourceReturnsUnwrappableError() {
        // given
        let localDataSourceMock = SearchResultLocalDataSourceMock()
        let repository = SearchResultRepository(localDataSource: localDataSourceMock, cloudDataSource: nil)
        var receivedError: Error?

        // when
        repository.searchByMedia(mediaType: "music", searchText: "Reggaeton", limit: 50)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error
                    }
                },
                receiveValue: { _ in XCTFail("Should fail with nil cloud data source") }
            )
            .store(in: &searchTokens)

        // then
        XCTAssertNotNil(receivedError)
        if let cloudError = receivedError as? CloudDataSourceDefaultError,
           case .unwrappableValue = cloudError {
            // Expected
        } else {
            XCTFail("Expected unwrappableValue error, got: \(String(describing: receivedError))")
        }
    }

    // MARK: - Tests: empty results

    func testSearchArtistWithEmptyResultsReturnsEmptyResultsArray() {
        // given
        let (repository, _) = makeRepository(status: .success, mockData: .emptyResults)

        // when / then
        repository.searchArtist(searchText: "qwerty12345xyz", limit: 50)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { searchResult in
                    XCTAssertEqual(searchResult.results?.count, 0)
                    XCTAssertEqual(searchResult.resultCount, 0)
                }
            )
            .store(in: &searchTokens)
    }
}
