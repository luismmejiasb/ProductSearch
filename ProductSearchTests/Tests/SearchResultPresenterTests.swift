import Combine
import XCTest
@testable import ProductSearch

// MARK: - SearchResultPresenterTests

@MainActor
class SearchResultPresenterTests: XCTestCase {
    // MARK: Properties

    private var viewMock: SearchResultViewMock!
    private var routerMock: SearchResultRouterMock!
    private var publisher: PassthroughSubject<SearchResultPublisherResult, Error>!

    // MARK: Selector constants

    private let displaySearchResultSelectorName = "displaySearchResult()"
    private let displayNextOffSetResultSelectorName = "displayNextOffSetResult(_:searchType:searchCategory:)"
    private let endLoadingIndicatorSelectorName = "endLoadingIndicator()"
    private let presentFilterTypeActionSheetSelectorName = "presentFilterTypeActionSheet()"
    private let presentProductDetailSelectorName = "presentProductDetail(_:)"
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
        mockData: SearchResultMLCDataMock = .multipleResults,
        interactorStatus: TransactionStatus = .success
    ) -> (SearchResultPresenter, SearchResultInteractorMock, SearchResult) {
        let cloudDataSourceMock = SearchResultCloudDataSourceMock(status: interactorStatus, mockData: mockData)
        let localDataSourceMock = SearchResultLocalDataSourceMock()
        let repositoryMock = SearchResultRepositoryMock(
            status: interactorStatus,
            localDataSource: localDataSourceMock,
            cloudDataSource: cloudDataSourceMock
        )
        let interactorMock = SearchResultInteractorMock(repository: repositoryMock)
        interactorMock.publisher = publisher

        let initialSearchResult = mockData.searchResult
        let presenter = SearchResultPresenter(
            interactor: interactorMock,
            router: routerMock,
            searchResult: initialSearchResult,
            searchType: searchType,
            searchCategory: searchCategory,
            searchText: initialSearchResult.query ?? "iphone"
        )
        presenter.view = viewMock
        presenter.viewDidLoad()
        return (presenter, interactorMock, initialSearchResult)
    }

    // MARK: - Tests: viewDidLoad

    func testViewDidLoadRegistersPublisherSubscription() {
        // given / when
        let (presenter, _, mockResult) = makeSUT()

        publisher.send(.displayNextOffSet(searchResult: mockResult))

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
        XCTAssertEqual(result?.siteID, initialResult.siteID)
    }

    func testGetSearchResultAfterSetSearchResultReturnsUpdatedResults() {
        // given
        let (presenter, _, _) = makeSUT()
        let newResults: [Result] = []

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
        let (presenter, _, _) = makeSUT(searchType: .category, searchCategory: .vehicule)

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

    func testGetSearchCategoryVehiculeReturnsVehicule() {
        // given / when
        let (presenter, _, _) = makeSUT(searchType: .category, searchCategory: .vehicule)

        // then
        XCTAssertEqual(presenter.getSearchCategory(), .vehicule)
    }

    func testGetSearchCategoryRealStateReturnsRealState() {
        // given / when
        let (presenter, _, _) = makeSUT(searchType: .category, searchCategory: .realState)

        // then
        XCTAssertEqual(presenter.getSearchCategory(), .realState)
    }

    func testGetSearchCategoryServicesReturnsServices() {
        // given / when
        let (presenter, _, _) = makeSUT(searchType: .category, searchCategory: .services)

        // then
        XCTAssertEqual(presenter.getSearchCategory(), .services)
    }

    // MARK: - Tests: fetchNextOffSet

    func testFetchNextOffSetFirstCallCallsInteractorWithOffset50() {
        // given
        let (presenter, interactorMock, _) = makeSUT(searchType: .text)

        // when
        presenter.fetchNextOffSet()

        // then
        XCTAssertEqual(interactorMock.functionsCalled.count, 1)
        XCTAssertEqual(interactorMock.lastOffSet, 50)
    }

    func testFetchNextOffSetSecondCallCallsInteractorWithOffset100() {
        // given
        let (presenter, interactorMock, _) = makeSUT(searchType: .text)

        // when
        presenter.fetchNextOffSet()
        presenter.fetchNextOffSet()

        // then
        XCTAssertEqual(interactorMock.functionsCalled.count, 2)
        XCTAssertEqual(interactorMock.lastOffSet, 100)
    }

    func testFetchNextOffSetThirdCallCallsInteractorWithOffset150() {
        // given
        let (presenter, interactorMock, _) = makeSUT(searchType: .text)

        // when
        presenter.fetchNextOffSet()
        presenter.fetchNextOffSet()
        presenter.fetchNextOffSet()

        // then
        XCTAssertEqual(interactorMock.lastOffSet, 150)
    }

    func testFetchNextOffSetTextTypeCallsSearchTextMethod() {
        // given
        let (presenter, interactorMock, _) = makeSUT(searchType: .text)

        // when
        presenter.fetchNextOffSet()

        // then
        XCTAssertEqual(interactorMock.functionsCalled.first, "fetchNextOffSet(_:searchText:)")
    }

    func testFetchNextOffSetCategoryTypeCallsCategoryMethod() {
        // given
        let (presenter, interactorMock, _) = makeSUT(
            searchType: .category,
            searchCategory: .vehicule,
            mockData: .categoryResults
        )

        // when
        presenter.fetchNextOffSet()

        // then
        XCTAssertEqual(interactorMock.functionsCalled.first, "fetchNextOffSet(_:category:)")
        XCTAssertEqual(interactorMock.lastCategory, HomeCategorySearch.vehicule.stringValue)
    }

    func testFetchNextOffSetCategoryRealStatePassesCorrectCategoryString() {
        // given
        let (presenter, interactorMock, _) = makeSUT(
            searchType: .category,
            searchCategory: .realState,
            mockData: .multipleResults
        )

        // when
        presenter.fetchNextOffSet()

        // then
        XCTAssertEqual(interactorMock.lastCategory, HomeCategorySearch.realState.stringValue)
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

    // MARK: - Tests: presentProductDetail

    func testPresentProductDetailCallsRouter() {
        // given
        let (presenter, _, initialResult) = makeSUT()
        guard let product = initialResult.results?.first else {
            XCTFail("Expected at least one result in mock data")
            return
        }

        // when
        presenter.presentProductDetail(product)

        // then
        XCTAssertEqual(routerMock.functionsCalled.count, 1)
        XCTAssertEqual(routerMock.functionsCalled[0], presentProductDetailSelectorName)
    }

    func testPresentProductDetailPassesCorrectProduct() {
        // given
        let (presenter, _, initialResult) = makeSUT()
        guard let product = initialResult.results?.first else {
            XCTFail("Expected at least one result in mock data")
            return
        }

        // when
        presenter.presentProductDetail(product)

        // then
        XCTAssertEqual(routerMock.lastPresentedProduct?.title, product.title)
        XCTAssertEqual(routerMock.lastPresentedProduct?.price, product.price)
    }

    // MARK: - Tests: Publisher displayNextOffSet

    func testPublisherDisplayNextOffSetCallsViewDisplayNextOffSetResult() {
        // given
        let (presenter, _, mockResult) = makeSUT(searchType: .text)

        // when
        publisher.send(.displayNextOffSet(searchResult: mockResult))

        // then
        XCTAssertTrue(viewMock.functionsCalled.contains(displayNextOffSetResultSelectorName))
        XCTAssertTrue(viewMock.functionsCalled.contains(endLoadingIndicatorSelectorName))
        _ = presenter
    }

    func testPublisherDisplayNextOffSetPassesCorrectSearchType() {
        // given
        let (presenter, _, mockResult) = makeSUT(searchType: .category, searchCategory: .vehicule)

        // when
        publisher.send(.displayNextOffSet(searchResult: mockResult))

        // then
        XCTAssertEqual(viewMock.lastSearchType, .category)
        _ = presenter
    }

    func testPublisherDisplayNextOffSetPassesCorrectSearchCategory() {
        // given
        let (presenter, _, mockResult) = makeSUT(searchType: .category, searchCategory: .vehicule)

        // when
        publisher.send(.displayNextOffSet(searchResult: mockResult))

        // then
        XCTAssertEqual(viewMock.lastSearchCategory, .vehicule)
        _ = presenter
    }

    func testPublisherDisplayNextOffSetPassesSearchResult() {
        // given
        let (presenter, _, mockResult) = makeSUT()

        // when
        publisher.send(.displayNextOffSet(searchResult: mockResult))

        // then
        XCTAssertNotNil(viewMock.lastNextOffSetResult)
        _ = presenter
    }

    // MARK: - Tests: Publisher displayNextOffSetFailed

    func testPublisherDisplayNextOffSetFailedHttpErrorCallsRouterDisplayAlert() {
        // given
        let (presenter, _, _) = makeSUT()
        let error = CloudDataSourceDefaultError.httpError(code: 1002, message: "Test Error")

        // when
        publisher.send(.displayNextOffSetFailed(error))

        // then
        XCTAssertTrue(viewMock.functionsCalled.contains(endLoadingIndicatorSelectorName))
        XCTAssertTrue(routerMock.functionsCalled.contains(displayAlertSelectorName))
        XCTAssertEqual(routerMock.lastAlertTitle, "Error")
        _ = presenter
    }

    func testPublisherDisplayNextOffSetFailedGenericErrorShowsDifferentAlertTitle() {
        // given
        let (presenter, _, _) = makeSUT()

        // when
        publisher.send(.displayNextOffSetFailed(CloudDataSourceDefaultError.responseCannotBeParsed))

        // then
        XCTAssertTrue(routerMock.functionsCalled.contains(displayAlertSelectorName))
        XCTAssertEqual(routerMock.lastAlertTitle, "Error en tu busqueda")
        _ = presenter
    }

    func testPublisherDisplayNextOffSetFailedDoesNotCallDisplayNextOffSetResult() {
        // given
        let (presenter, _, _) = makeSUT()

        // when
        publisher.send(.displayNextOffSetFailed(CloudDataSourceDefaultError.unwrappableValue))

        // then
        XCTAssertFalse(viewMock.functionsCalled.contains(displayNextOffSetResultSelectorName))
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
        let (presenter, _, _) = makeSUT(mockData: .multipleResults)
        // Prices in mock: 600000, 350000, 480000 → after sort: 350000, 480000, 600000

        // when
        presenter.didSelectFilter(.lowestPrice)

        // then
        let results = presenter.getSearchResult()?.results
        let prices = results?.compactMap { $0.price } ?? []
        XCTAssertEqual(prices, prices.sorted())
    }

    func testDidSelectFilterHighestPriceSortsDescending() {
        // given
        let (presenter, _, _) = makeSUT(mockData: .multipleResults)
        // Prices: 600000, 350000, 480000 → after sort: 600000, 480000, 350000

        // when
        presenter.didSelectFilter(.highestPrice)

        // then
        let results = presenter.getSearchResult()?.results
        let prices = results?.compactMap { $0.price } ?? []
        XCTAssertEqual(prices, prices.sorted(by: >))
    }

    func testDidSelectFilterHighestPriceFirstItemHasHighestPrice() {
        // given
        let (presenter, _, _) = makeSUT(mockData: .multipleResults)

        // when
        presenter.didSelectFilter(.highestPrice)

        // then
        let results = presenter.getSearchResult()?.results
        XCTAssertEqual(results?.first?.price, 600000)
    }

    func testDidSelectFilterLowestPriceFirstItemHasLowestPrice() {
        // given
        let (presenter, _, _) = makeSUT(mockData: .multipleResults)

        // when
        presenter.didSelectFilter(.lowestPrice)

        // then
        let results = presenter.getSearchResult()?.results
        XCTAssertEqual(results?.first?.price, 350000)
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

    // MARK: - Tests: fetchNextOffSet triggers interactor via publisher

    func testFetchNextOffSetSuccessViewReceivesNextOffset() {
        // given
        let (presenter, interactorMock, _) = makeSUT(status: .success)

        // when
        presenter.fetchNextOffSet()
        let mockResult = SearchResultMLCDataMock.multipleResults.searchResult
        publisher.send(.displayNextOffSet(searchResult: mockResult))

        // then
        XCTAssertTrue(viewMock.functionsCalled.contains(displayNextOffSetResultSelectorName))
        _ = interactorMock
    }
}

// MARK: - SearchResultPresenterTests + Status convenience init

private extension SearchResultPresenterTests {
    func makeSUT(
        status: TransactionStatus,
        searchType: SearchType = .text,
        searchCategory: HomeCategorySearch = .none
    ) -> (SearchResultPresenter, SearchResultInteractorMock, SearchResult) {
        makeSUT(
            searchType: searchType,
            searchCategory: searchCategory,
            mockData: .multipleResults,
            interactorStatus: status
        )
    }
}
