import Combine
import XCTest
@testable import ArtistSearch

// MARK: - SearchResultPresenterTests

@MainActor
class SearchResultPresenterTests: XCTestCase {
    // MARK: Properties

    private var viewMock: SearchResultViewMock!
    private var routerMock: SearchResultRouterMock!
    private var publisher: PassthroughSubject<SearchResultPublisherResult, Error>!

    // MARK: Selector constants

    private let displaySearchResultSelectorName = "displaySearchResult()"
    private let displayNextPageResultSelectorName = "displayNextPageResult(_:searchType:searchCategory:)"
    private let endLoadingIndicatorSelectorName = "endLoadingIndicator()"
    private let presentFilterTypeActionSheetSelectorName = "presentFilterTypeActionSheet()"
    private let presentArtistDetailSelectorName = "presentArtistDetail(_:)"
    private let displayAlertSelectorName = "displayAlert(title:message:)"

    // MARK: Lifecycle

    override func setUp() {
        super.setUp()
        viewMock = SearchResultViewMock()
        routerMock = SearchResultRouterMock()
        publisher = PassthroughSubject<SearchResultPublisherResult, Error>()
    }

    override func tearDown() {
        viewMock = nil
        routerMock = nil
        publisher = nil
        super.tearDown()
    }

    // MARK: Helpers

    private func makeSUT(
        searchType: SearchType = .text,
        searchCategory: HomeCategorySearch = .none,
        mockData: SearchResultITunesDataMock = .multipleResults,
        interactorStatus: TransactionStatus = .success
    ) -> (SearchResultPresenter, SearchResultInteractorMock, ArtistSearchResult) {
        let cloudDataSourceMock = SearchResultCloudDataSourceMock(status: interactorStatus, mockData: mockData)
        let localDataSourceMock = SearchResultLocalDataSourceMock()
        let repositoryMock = SearchResultRepositoryMock(
            localDataSource: localDataSourceMock,
            cloudDataSource: cloudDataSourceMock
        )
        let interactorMock = SearchResultInteractorMock(repository: repositoryMock, publisher: publisher)

        let initialSearchResult = mockData.searchResult
        let presenter = SearchResultPresenter(
            interactor: interactorMock,
            router: routerMock,
            searchResult: initialSearchResult,
            searchType: searchType,
            searchCategory: searchCategory,
            searchText: initialSearchResult.searchText ?? "iphone"
        )
        presenter.view = viewMock
        presenter.viewDidLoad()
        return (presenter, interactorMock, initialSearchResult)
    }

    // MARK: - Tests: viewDidLoad

    func testViewDidLoadRegistersPublisherSubscription() {
        // given / when
        let (presenter, _, mockResult) = makeSUT()

        publisher.send(.displayNextPage(searchResult: mockResult))

        // then
        XCTAssertTrue(viewMock.functionsCalled.contains(endLoadingIndicatorSelectorName))
        _ = presenter
    }

    // MARK: - Tests: getSearchResult

    func testGetSearchResultReturnsInitialResult() {
        // given
        let (presenter, _, initialResult) = makeSUT()

        // when
        let result = presenter.getSearchResult()

        // then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.resultCount, initialResult.resultCount)
    }

    func testGetSearchResultAfterSetSearchResultReturnsUpdatedResults() {
        // given
        let (presenter, _, _) = makeSUT()
        let newResults: [ArtistResult] = []

        // when
        presenter.setSearchResult(results: newResults)
        let result = presenter.getSearchResult()

        // then
        XCTAssertEqual(result?.results?.count, 0)
    }

    func testSetSearchResultWithNilResultsUpdatesResultsToNil() {
        // given
        let (presenter, _, _) = makeSUT()

        // when
        presenter.setSearchResult(results: nil)
        let result = presenter.getSearchResult()

        // then
        XCTAssertNil(result?.results)
    }

    // MARK: - Tests: getSearchType

    func testGetSearchTypeTextReturnsText() {
        // given / when
        let (presenter, _, _) = makeSUT(searchType: .text)

        // then
        XCTAssertEqual(presenter.getSearchType(), .text)
    }

    func testGetSearchTypeCategoryReturnsCategory() {
        // given / when
        let (presenter, _, _) = makeSUT(searchType: .category, searchCategory: .reggaeton)

        // then
        XCTAssertEqual(presenter.getSearchType(), .category)
    }

    // MARK: - Tests: getSearchCategory

    func testGetSearchCategoryNoneReturnsNone() {
        // given / when
        let (presenter, _, _) = makeSUT(searchCategory: .none)

        // then
        XCTAssertEqual(presenter.getSearchCategory(), .none)
    }

    func testGetSearchCategoryMusicReturnsMusic() {
        // given / when
        let (presenter, _, _) = makeSUT(searchType: .category, searchCategory: .reggaeton)

        // then
        XCTAssertEqual(presenter.getSearchCategory(), .reggaeton)
    }

    func testGetSearchCategoryMoviesReturnsMovies() {
        // given / when
        let (presenter, _, _) = makeSUT(searchType: .category, searchCategory: .salsa)

        // then
        XCTAssertEqual(presenter.getSearchCategory(), .salsa)
    }

    func testGetSearchCategoryPodcastsReturnsPodcasts() {
        // given / when
        let (presenter, _, _) = makeSUT(searchType: .category, searchCategory: .rock)

        // then
        XCTAssertEqual(presenter.getSearchCategory(), .rock)
    }

    // MARK: - Tests: fetchNextPage

    func testFetchNextPageFirstCallCallsInteractor() {
        // given
        let (presenter, interactorMock, _) = makeSUT(searchType: .text)

        // when
        presenter.fetchNextPage()

        // then
        XCTAssertEqual(interactorMock.functionsCalled.count, 1)
    }

    func testFetchNextPageSecondCallCallsInteractorTwice() {
        // given
        let (presenter, interactorMock, _) = makeSUT(searchType: .text)

        // when
        presenter.fetchNextPage()
        presenter.fetchNextPage()

        // then
        XCTAssertEqual(interactorMock.functionsCalled.count, 2)
    }

    func testFetchNextPageTextTypeCallsSearchTextMethod() {
        // given
        let (presenter, interactorMock, _) = makeSUT(searchType: .text)

        // when
        presenter.fetchNextPage()

        // then
        XCTAssertEqual(interactorMock.functionsCalled.first, "fetchNextPage(searchText:limit:)")
    }

    func testFetchNextPageCategoryTypeCallsCategoryMethod() {
        // given
        let (presenter, interactorMock, _) = makeSUT(
            searchType: .category,
            searchCategory: .reggaeton,
            mockData: .multipleResults
        )

        // when
        presenter.fetchNextPage()

        // then
        XCTAssertEqual(interactorMock.functionsCalled.first, "fetchNextPageByMedia(mediaType:searchText:limit:)")
        XCTAssertEqual(interactorMock.lastMediaType, HomeCategorySearch.reggaeton.mediaType)
    }

    // MARK: - Tests: presentFilterTypeActionSheet

    func testPresentFilterTypeActionSheetCallsRouter() {
        // given
        let (presenter, _, _) = makeSUT()

        // when
        presenter.presentFilterTypeActionSheet()

        // then
        XCTAssertEqual(routerMock.functionsCalled.count, 1)
        XCTAssertEqual(routerMock.functionsCalled[0], presentFilterTypeActionSheetSelectorName)
    }

    // MARK: - Tests: presentArtistDetail

    func testPresentArtistDetailCallsRouter() {
        // given
        let (presenter, _, initialResult) = makeSUT()
        guard let artist = initialResult.results?.first else {
            XCTFail("Expected at least one result in mock data")
            return
        }

        // when
        presenter.presentArtistDetail(artist)

        // then
        XCTAssertEqual(routerMock.functionsCalled.count, 1)
        XCTAssertEqual(routerMock.functionsCalled[0], presentArtistDetailSelectorName)
    }

    func testPresentArtistDetailPassesCorrectArtist() {
        // given
        let (presenter, _, initialResult) = makeSUT()
        guard let artist = initialResult.results?.first else {
            XCTFail("Expected at least one result in mock data")
            return
        }

        // when
        presenter.presentArtistDetail(artist)

        // then
        XCTAssertEqual(routerMock.lastPresentedArtist?.artistName, artist.artistName)
        XCTAssertEqual(routerMock.lastPresentedArtist?.trackPrice, artist.trackPrice)
    }

    // MARK: - Tests: Publisher displayNextPage

    func testPublisherDisplayNextPageCallsViewDisplayNextPageResult() {
        // given
        let (presenter, _, mockResult) = makeSUT(searchType: .text)

        // when
        publisher.send(.displayNextPage(searchResult: mockResult))

        // then
        XCTAssertTrue(viewMock.functionsCalled.contains(displayNextPageResultSelectorName))
        XCTAssertTrue(viewMock.functionsCalled.contains(endLoadingIndicatorSelectorName))
        _ = presenter
    }

    func testPublisherDisplayNextPagePassesCorrectSearchType() {
        // given
        let (presenter, _, mockResult) = makeSUT(searchType: .category, searchCategory: .reggaeton)

        // when
        publisher.send(.displayNextPage(searchResult: mockResult))

        // then
        XCTAssertEqual(viewMock.lastSearchType, .category)
        _ = presenter
    }

    func testPublisherDisplayNextPagePassesCorrectSearchCategory() {
        // given
        let (presenter, _, mockResult) = makeSUT(searchType: .category, searchCategory: .reggaeton)

        // when
        publisher.send(.displayNextPage(searchResult: mockResult))

        // then
        XCTAssertEqual(viewMock.lastSearchCategory, .reggaeton)
        _ = presenter
    }

    func testPublisherDisplayNextPagePassesSearchResult() {
        // given
        let (presenter, _, mockResult) = makeSUT()

        // when
        publisher.send(.displayNextPage(searchResult: mockResult))

        // then
        XCTAssertNotNil(viewMock.lastNextPageResult)
        _ = presenter
    }

    // MARK: - Tests: Publisher displayNextPageFailed

    func testPublisherDisplayNextPageFailedHttpErrorCallsRouterDisplayAlert() {
        // given
        let (presenter, _, _) = makeSUT()
        let error = CloudDataSourceDefaultError.httpError(code: 1002, message: "Test Error")

        // when
        publisher.send(.displayNextPageFailed(error))

        // then
        XCTAssertTrue(viewMock.functionsCalled.contains(endLoadingIndicatorSelectorName))
        XCTAssertTrue(routerMock.functionsCalled.contains(displayAlertSelectorName))
        XCTAssertEqual(routerMock.lastAlertTitle, "Error")
        _ = presenter
    }

    func testPublisherDisplayNextPageFailedGenericErrorShowsDifferentAlertTitle() {
        // given
        let (presenter, _, _) = makeSUT()

        // when
        publisher.send(.displayNextPageFailed(CloudDataSourceDefaultError.responseCannotBeParsed))

        // then
        XCTAssertTrue(routerMock.functionsCalled.contains(displayAlertSelectorName))
        XCTAssertEqual(routerMock.lastAlertTitle, "Error en tu busqueda")
        _ = presenter
    }

    func testPublisherDisplayNextPageFailedDoesNotCallDisplayNextPageResult() {
        // given
        let (presenter, _, _) = makeSUT()

        // when
        publisher.send(.displayNextPageFailed(CloudDataSourceDefaultError.unwrappableValue))

        // then
        XCTAssertFalse(viewMock.functionsCalled.contains(displayNextPageResultSelectorName))
        _ = presenter
    }

    // MARK: - Tests: Publisher completion

    func testPublisherCompletionFinishedCallsEndLoading() {
        // given
        let (presenter, _, _) = makeSUT()

        // when
        publisher.send(completion: .finished)

        // then
        XCTAssertTrue(viewMock.functionsCalled.contains(endLoadingIndicatorSelectorName))
        _ = presenter
    }

    func testPublisherCompletionFailureCallsEndLoadingAndAlert() {
        // given
        let (presenter, _, _) = makeSUT()

        // when
        publisher.send(completion: .failure(CloudDataSourceDefaultError.httpError(code: 503, message: "Unavailable")))

        // then
        XCTAssertTrue(viewMock.functionsCalled.contains(endLoadingIndicatorSelectorName))
        XCTAssertTrue(routerMock.functionsCalled.contains(displayAlertSelectorName))
        _ = presenter
    }

    // MARK: - Tests: didSelectFilter (via RouterDelegate)

    func testDidSelectFilterLowestPriceSortsAscending() {
        // given
        // Prices in mock: 1.29, 0.99, 1.49 → after sort ascending: 0.99, 1.29, 1.49
        let (presenter, _, _) = makeSUT(mockData: .multipleResults)

        // when
        presenter.didSelectFilter(.lowestPrice)

        // then
        let results = presenter.getSearchResult()?.results
        let prices = results?.compactMap { $0.trackPrice } ?? []
        XCTAssertEqual(prices, prices.sorted())
    }

    func testDidSelectFilterHighestPriceSortsDescending() {
        // given
        // Prices: 1.29, 0.99, 1.49 → after sort descending: 1.49, 1.29, 0.99
        let (presenter, _, _) = makeSUT(mockData: .multipleResults)

        // when
        presenter.didSelectFilter(.highestPrice)

        // then
        let results = presenter.getSearchResult()?.results
        let prices = results?.compactMap { $0.trackPrice } ?? []
        XCTAssertEqual(prices, prices.sorted(by: >))
    }

    func testDidSelectFilterHighestPriceFirstItemHasHighestPrice() {
        // given
        let (presenter, _, _) = makeSUT(mockData: .multipleResults)

        // when
        presenter.didSelectFilter(.highestPrice)

        // then
        let results = presenter.getSearchResult()?.results
        XCTAssertEqual(results?.first?.trackPrice, 1.49)
    }

    func testDidSelectFilterLowestPriceFirstItemHasLowestPrice() {
        // given
        let (presenter, _, _) = makeSUT(mockData: .multipleResults)

        // when
        presenter.didSelectFilter(.lowestPrice)

        // then
        let results = presenter.getSearchResult()?.results
        XCTAssertEqual(results?.first?.trackPrice, 0.99)
    }

    func testDidSelectFilterHighestPriceCallsDisplaySearchResultOnce() {
        // given
        let (presenter, _, _) = makeSUT(mockData: .multipleResults)

        // when
        presenter.didSelectFilter(.highestPrice)

        // then
        let calls = viewMock.functionsCalled.filter { $0 == displaySearchResultSelectorName }
        XCTAssertEqual(calls.count, 1)
    }

    func testDidSelectFilterLowestPriceCallsDisplaySearchResultTwice() {
        // given — documents known behavior: lowestPrice calls displaySearchResult
        // both inside the switch case AND after the switch statement.
        let (presenter, _, _) = makeSUT(mockData: .multipleResults)

        // when
        presenter.didSelectFilter(.lowestPrice)

        // then
        let calls = viewMock.functionsCalled.filter { $0 == displaySearchResultSelectorName }
        XCTAssertEqual(calls.count, 2)
        _ = presenter
    }

    func testDidSelectFilterWhenResultsIsNilDoesNotCallView() {
        // given
        let (presenter, _, _) = makeSUT()
        presenter.setSearchResult(results: nil)
        viewMock.functionsCalled.removeAll()

        // when
        presenter.didSelectFilter(.lowestPrice)

        // then
        XCTAssertFalse(viewMock.functionsCalled.contains(displaySearchResultSelectorName))
    }

    // MARK: - Tests: fetchNextPage triggers interactor via publisher

    func testFetchNextPageSuccessViewReceivesNextPage() {
        // given
        let (presenter, interactorMock, _) = makeSUT(interactorStatus: .success)

        // when
        presenter.fetchNextPage()
        let mockResult = SearchResultITunesDataMock.multipleResults.searchResult
        publisher.send(.displayNextPage(searchResult: mockResult))

        // then
        XCTAssertTrue(viewMock.functionsCalled.contains(displayNextPageResultSelectorName))
        _ = interactorMock
    }
}

// MARK: - SearchResultPresenterTests + Status convenience init

private extension SearchResultPresenterTests {
    func makeSUT(
        status: TransactionStatus,
        searchType: SearchType = .text,
        searchCategory: HomeCategorySearch = .none
    ) -> (SearchResultPresenter, SearchResultInteractorMock, ArtistSearchResult) {
        makeSUT(
            searchType: searchType,
            searchCategory: searchCategory,
            mockData: .multipleResults,
            interactorStatus: status
        )
    }
}
