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

        let initialSearchResult = mockData.searchResult!
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

    func testViewDidLoad_registersPublisherSubscription() {
        let (presenter, _, mockResult) = makeSUT()

        publisher.send(.displayNextOffSet(searchResult: mockResult))

        XCTAssertTrue(viewMock.functionsCalled.contains(endLoadingIndicatorSelectorName))
        _ = presenter
    }

    // MARK: - Tests: getSearchResult

    func testGetSearchResult_returnsInitialResult() {
        let (presenter, _, initialResult) = makeSUT()

        let result = presenter.getSearchResult()

        XCTAssertNotNil(result)
        XCTAssertEqual(result?.siteID, initialResult.siteID)
    }

    func testGetSearchResult_afterSetSearchResult_returnsUpdatedResults() {
        let (presenter, _, _) = makeSUT()
        let newResults: [Result] = []

        presenter.setSearchResult(results: newResults)
        let result = presenter.getSearchResult()

        XCTAssertEqual(result?.results?.count, 0)
    }

    func testSetSearchResult_withNilResults_updatesResultsToNil() {
        let (presenter, _, _) = makeSUT()

        presenter.setSearchResult(results: nil)
        let result = presenter.getSearchResult()

        XCTAssertNil(result?.results)
    }

    // MARK: - Tests: getSearchType

    func testGetSearchType_text_returnsText() {
        let (presenter, _, _) = makeSUT(searchType: .text)

        XCTAssertEqual(presenter.getSearchType(), .text)
    }

    func testGetSearchType_category_returnsCategory() {
        let (presenter, _, _) = makeSUT(searchType: .category, searchCategory: .vehicule)

        XCTAssertEqual(presenter.getSearchType(), .category)
    }

    // MARK: - Tests: getSearchCategory

    func testGetSearchCategory_none_returnsNone() {
        let (presenter, _, _) = makeSUT(searchCategory: .none)

        XCTAssertEqual(presenter.getSearchCategory(), .none)
    }

    func testGetSearchCategory_vehicule_returnsVehicule() {
        let (presenter, _, _) = makeSUT(searchType: .category, searchCategory: .vehicule)

        XCTAssertEqual(presenter.getSearchCategory(), .vehicule)
    }

    func testGetSearchCategory_realState_returnsRealState() {
        let (presenter, _, _) = makeSUT(searchType: .category, searchCategory: .realState)

        XCTAssertEqual(presenter.getSearchCategory(), .realState)
    }

    func testGetSearchCategory_services_returnsServices() {
        let (presenter, _, _) = makeSUT(searchType: .category, searchCategory: .services)

        XCTAssertEqual(presenter.getSearchCategory(), .services)
    }

    // MARK: - Tests: fetchNextOffSet

    func testFetchNextOffSet_firstCall_callsInteractorWithOffset50() {
        let (presenter, interactorMock, _) = makeSUT(searchType: .text)

        presenter.fetchNextOffSet()

        XCTAssertEqual(interactorMock.functionsCalled.count, 1)
        XCTAssertEqual(interactorMock.lastOffSet, 50)
    }

    func testFetchNextOffSet_secondCall_callsInteractorWithOffset100() {
        let (presenter, interactorMock, _) = makeSUT(searchType: .text)

        presenter.fetchNextOffSet()
        presenter.fetchNextOffSet()

        XCTAssertEqual(interactorMock.functionsCalled.count, 2)
        XCTAssertEqual(interactorMock.lastOffSet, 100)
    }

    func testFetchNextOffSet_thirdCall_callsInteractorWithOffset150() {
        let (presenter, interactorMock, _) = makeSUT(searchType: .text)

        presenter.fetchNextOffSet()
        presenter.fetchNextOffSet()
        presenter.fetchNextOffSet()

        XCTAssertEqual(interactorMock.lastOffSet, 150)
    }

    func testFetchNextOffSet_textType_callsSearchTextMethod() {
        let (presenter, interactorMock, _) = makeSUT(searchType: .text)

        presenter.fetchNextOffSet()

        XCTAssertEqual(interactorMock.functionsCalled.first, "fetchNextOffSet(_:searchText:)")
    }

    func testFetchNextOffSet_categoryType_callsCategoryMethod() {
        let (presenter, interactorMock, _) = makeSUT(
            searchType: .category,
            searchCategory: .vehicule,
            mockData: .categoryResults
        )

        presenter.fetchNextOffSet()

        XCTAssertEqual(interactorMock.functionsCalled.first, "fetchNextOffSet(_:category:)")
        XCTAssertEqual(interactorMock.lastCategory, HomeCategorySearch.vehicule.stringValue)
    }

    func testFetchNextOffSet_categoryRealState_passesCorrectCategoryString() {
        let (presenter, interactorMock, _) = makeSUT(
            searchType: .category,
            searchCategory: .realState,
            mockData: .multipleResults
        )

        presenter.fetchNextOffSet()

        XCTAssertEqual(interactorMock.lastCategory, HomeCategorySearch.realState.stringValue)
    }

    // MARK: - Tests: presentFilterTypeActionSheet

    func testPresentFilterTypeActionSheet_callsRouter() {
        let (presenter, _, _) = makeSUT()

        presenter.presentFilterTypeActionSheet()

        XCTAssertEqual(routerMock.functionsCalled.count, 1)
        XCTAssertEqual(routerMock.functionsCalled[0], presentFilterTypeActionSheetSelectorName)
    }

    // MARK: - Tests: presentProductDetail

    func testPresentProductDetail_callsRouter() {
        let (presenter, _, initialResult) = makeSUT()
        let product = initialResult.results![0]

        presenter.presentProductDetail(product)

        XCTAssertEqual(routerMock.functionsCalled.count, 1)
        XCTAssertEqual(routerMock.functionsCalled[0], presentProductDetailSelectorName)
    }

    func testPresentProductDetail_passesCorrectProduct() {
        let (presenter, _, initialResult) = makeSUT()
        let product = initialResult.results![0]

        presenter.presentProductDetail(product)

        XCTAssertEqual(routerMock.lastPresentedProduct?.title, product.title)
        XCTAssertEqual(routerMock.lastPresentedProduct?.price, product.price)
    }

    // MARK: - Tests: Publisher displayNextOffSet

    func testPublisher_displayNextOffSet_callsViewDisplayNextOffSetResult() {
        let (presenter, _, mockResult) = makeSUT(searchType: .text)

        publisher.send(.displayNextOffSet(searchResult: mockResult))

        XCTAssertTrue(viewMock.functionsCalled.contains(displayNextOffSetResultSelectorName))
        XCTAssertTrue(viewMock.functionsCalled.contains(endLoadingIndicatorSelectorName))
        _ = presenter
    }

    func testPublisher_displayNextOffSet_passesCorrectSearchType() {
        let (presenter, _, mockResult) = makeSUT(searchType: .category, searchCategory: .vehicule)

        publisher.send(.displayNextOffSet(searchResult: mockResult))

        XCTAssertEqual(viewMock.lastSearchType, .category)
        _ = presenter
    }

    func testPublisher_displayNextOffSet_passesCorrectSearchCategory() {
        let (presenter, _, mockResult) = makeSUT(searchType: .category, searchCategory: .vehicule)

        publisher.send(.displayNextOffSet(searchResult: mockResult))

        XCTAssertEqual(viewMock.lastSearchCategory, .vehicule)
        _ = presenter
    }

    func testPublisher_displayNextOffSet_passesSearchResult() {
        let (presenter, _, mockResult) = makeSUT()

        publisher.send(.displayNextOffSet(searchResult: mockResult))

        XCTAssertNotNil(viewMock.lastNextOffSetResult)
        _ = presenter
    }

    // MARK: - Tests: Publisher displayNextOffSetFailed

    func testPublisher_displayNextOffSetFailed_httpError_callsRouterDisplayAlert() {
        let (presenter, _, _) = makeSUT()
        let error = CloudDataSourceDefaultError.httpError(code: 1002, message: "Test Error")

        publisher.send(.displayNextOffSetFailed(error))

        XCTAssertTrue(viewMock.functionsCalled.contains(endLoadingIndicatorSelectorName))
        XCTAssertTrue(routerMock.functionsCalled.contains(displayAlertSelectorName))
        XCTAssertEqual(routerMock.lastAlertTitle, "Error")
        _ = presenter
    }

    func testPublisher_displayNextOffSetFailed_genericError_showsDifferentAlertTitle() {
        let (presenter, _, _) = makeSUT()

        publisher.send(.displayNextOffSetFailed(CloudDataSourceDefaultError.responseCannotBeParsed))

        XCTAssertTrue(routerMock.functionsCalled.contains(displayAlertSelectorName))
        XCTAssertEqual(routerMock.lastAlertTitle, "Error en tu busqueda")
        _ = presenter
    }

    func testPublisher_displayNextOffSetFailed_doesNotCallDisplayNextOffSetResult() {
        let (presenter, _, _) = makeSUT()

        publisher.send(.displayNextOffSetFailed(CloudDataSourceDefaultError.unwrappableValue))

        XCTAssertFalse(viewMock.functionsCalled.contains(displayNextOffSetResultSelectorName))
        _ = presenter
    }

    // MARK: - Tests: Publisher completion

    func testPublisher_completionFinished_callsEndLoading() {
        let (presenter, _, _) = makeSUT()

        publisher.send(completion: .finished)

        XCTAssertTrue(viewMock.functionsCalled.contains(endLoadingIndicatorSelectorName))
        _ = presenter
    }

    func testPublisher_completionFailure_callsEndLoadingAndAlert() {
        let (presenter, _, _) = makeSUT()

        publisher.send(completion: .failure(CloudDataSourceDefaultError.httpError(code: 503, message: "Unavailable")))

        XCTAssertTrue(viewMock.functionsCalled.contains(endLoadingIndicatorSelectorName))
        XCTAssertTrue(routerMock.functionsCalled.contains(displayAlertSelectorName))
        _ = presenter
    }

    // MARK: - Tests: didSelectFilter (via RouterDelegate)

    func testDidSelectFilter_lowestPrice_sortsAscending() {
        let (presenter, _, _) = makeSUT(mockData: .multipleResults)
        // Prices in mock: 600000, 350000, 480000
        // After sort: 350000, 480000, 600000

        presenter.didSelectFilter(.lowestPrice)

        let results = presenter.getSearchResult()?.results
        let prices = results?.compactMap { $0.price } ?? []
        XCTAssertEqual(prices, prices.sorted())
    }

    func testDidSelectFilter_highestPrice_sortsDescending() {
        let (presenter, _, _) = makeSUT(mockData: .multipleResults)
        // Prices: 600000, 350000, 480000
        // After sort: 600000, 480000, 350000

        presenter.didSelectFilter(.highestPrice)

        let results = presenter.getSearchResult()?.results
        let prices = results?.compactMap { $0.price } ?? []
        XCTAssertEqual(prices, prices.sorted(by: >))
    }

    func testDidSelectFilter_highestPrice_firstItemHasHighestPrice() {
        let (presenter, _, _) = makeSUT(mockData: .multipleResults)

        presenter.didSelectFilter(.highestPrice)

        let results = presenter.getSearchResult()?.results
        XCTAssertEqual(results?.first?.price, 600000)
    }

    func testDidSelectFilter_lowestPrice_firstItemHasLowestPrice() {
        let (presenter, _, _) = makeSUT(mockData: .multipleResults)

        presenter.didSelectFilter(.lowestPrice)

        let results = presenter.getSearchResult()?.results
        XCTAssertEqual(results?.first?.price, 350000)
    }

    func testDidSelectFilter_highestPrice_callsDisplaySearchResultOnce() {
        let (presenter, _, _) = makeSUT(mockData: .multipleResults)

        presenter.didSelectFilter(.highestPrice)

        let calls = viewMock.functionsCalled.filter { $0 == displaySearchResultSelectorName }
        XCTAssertEqual(calls.count, 1)
    }

    func testDidSelectFilter_lowestPrice_callsDisplaySearchResultTwice() {
        // Note: This documents a known behavior in the presenter where lowestPrice
        // calls displaySearchResult both inside the case and after the switch.
        let (presenter, _, _) = makeSUT(mockData: .multipleResults)

        presenter.didSelectFilter(.lowestPrice)

        let calls = viewMock.functionsCalled.filter { $0 == displaySearchResultSelectorName }
        XCTAssertEqual(calls.count, 2)
        _ = presenter
    }

    func testDidSelectFilter_whenResultsIsNil_doesNotCallView() {
        let (presenter, _, _) = makeSUT()
        presenter.setSearchResult(results: nil)
        viewMock.functionsCalled.removeAll()

        presenter.didSelectFilter(.lowestPrice)

        XCTAssertFalse(viewMock.functionsCalled.contains(displaySearchResultSelectorName))
    }

    // MARK: - Tests: fetchNextOffSet triggers interactor via publisher

    func testFetchNextOffSet_success_viewReceivesNextOffset() {
        let (presenter, interactorMock, _) = makeSUT(status: .success)

        presenter.fetchNextOffSet()
        // Simulate the interactor publishing the result
        let mockResult = SearchResultMLCDataMock.multipleResults.searchResult!
        publisher.send(.displayNextOffSet(searchResult: mockResult))

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
