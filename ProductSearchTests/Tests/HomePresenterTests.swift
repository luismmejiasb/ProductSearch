import Combine
import XCTest
@testable import ProductSearch

// MARK: - HomePresenterTests

@MainActor
class HomePresenterTests: XCTestCase {
    // MARK: Properties

    private var viewMock: HomeViewMock!
    private var routerMock: HomeRouterMock!
    private var publisher: PassthroughSubject<HomePublisherResult, Error>!
    private var searchTokens = Set<AnyCancellable>()

    // MARK: Selector constants

    private let serachItemSelectorName = "serachItem(searchText:)"
    private let searchByCategorySelectorName = "searchByCategory(_:)"
    private let endLoadingIndicatorSelectorName = "endLoadingIndicator()"
    private let displaySearchResultSelectorName = "displaySearchResult(_:searchType:searchCategory:)"
    private let presentSearchResultSelectorName = "presentSearchResult(_:searchType:searchCategory:)"
    private let displayAlertSelectorName = "displayAlert(title:message:)"

    // MARK: Lifecycle

    override func setUp() {
        super.setUp()
        viewMock = HomeViewMock()
        routerMock = HomeRouterMock()
        publisher = PassthroughSubject<HomePublisherResult, Error>()
    }

    override func tearDown() {
        viewMock = nil
        routerMock = nil
        publisher = nil
        searchTokens.removeAll()
        super.tearDown()
    }

    // MARK: Helpers

    private func makeSUT(status: TransactionStatus = .success) -> (HomePresenter, HomeInteractorMock) {
        let cloudDataSourceMock = HomeCloudDataSourceMock(status: status)
        let localDataSourceMock = HomeLocalDataSourceMock()
        let repositoryMock = HomeRepositoryMock(
            status: status,
            localDataSource: localDataSourceMock,
            cloudDataSource: cloudDataSourceMock
        )
        let interactorMock = HomeInteractorMock(repository: repositoryMock)
        interactorMock.publisher = publisher
        let presenter = HomePresenter(interactor: interactorMock, router: routerMock)
        presenter.view = viewMock
        presenter.viewDidLoad()
        return (presenter, interactorMock)
    }

    // MARK: - Tests: searchItem

    func testSearchItem_withSuccess_callsInteractorAndView() {
        let (presenter, interactorMock) = makeSUT(status: .success)

        presenter.searchItem(searchText: "iPhone")

        XCTAssertEqual(interactorMock.functionsCalled.count, 1)
        XCTAssertEqual(interactorMock.functionsCalled[0], serachItemSelectorName)
        XCTAssertEqual(viewMock.functionsCalled.count, 2)
        XCTAssertEqual(viewMock.functionsCalled[0], endLoadingIndicatorSelectorName)
        XCTAssertEqual(viewMock.functionsCalled[1], displaySearchResultSelectorName)
        XCTAssertEqual(viewMock.lastSearchType, .text)
        XCTAssertEqual(viewMock.lastSearchCategory, .none)
    }

    func testSearchItem_withSuccess_searchResultIsNotNil() {
        let (presenter, _) = makeSUT(status: .success)

        presenter.searchItem(searchText: "iPod Nano")

        XCTAssertNotNil(viewMock.lastSearchResult)
    }

    func testSearchItem_withHTTPError_callsRouterDisplayAlert() {
        let (presenter, interactorMock) = makeSUT(status: .failure)

        presenter.searchItem(searchText: "iPhone")

        XCTAssertEqual(interactorMock.functionsCalled.first, serachItemSelectorName)
        XCTAssertTrue(viewMock.functionsCalled.contains(endLoadingIndicatorSelectorName))
        XCTAssertTrue(routerMock.functionsCalled.contains(displayAlertSelectorName))
        XCTAssertEqual(routerMock.lastAlertTitle, "Error")
        XCTAssertFalse(routerMock.lastAlertMessage.isEmpty)
    }

    func testSearchItem_withHTTPError_doesNotCallDisplaySearchResult() {
        let (presenter, _) = makeSUT(status: .failure)

        presenter.searchItem(searchText: "iPhone")

        XCTAssertFalse(viewMock.functionsCalled.contains(displaySearchResultSelectorName))
        _ = presenter
    }

    func testSearchItem_publisherSendsGenericError_showsDifferentAlertTitle() {
        let (presenter, _) = makeSUT()

        publisher.send(.itemsSearchedWithFailure(CloudDataSourceDefaultError.responseCannotBeParsed))

        XCTAssertTrue(routerMock.functionsCalled.contains(displayAlertSelectorName))
        XCTAssertEqual(routerMock.lastAlertTitle, "Error en tu busqueda")
        _ = presenter
    }

    func testSearchItem_doesNotCallRouter_onSuccess() {
        let (presenter, _) = makeSUT(status: .success)

        presenter.searchItem(searchText: "iPhone")

        XCTAssertTrue(routerMock.functionsCalled.isEmpty)
        _ = presenter
    }

    // MARK: - Tests: searchByCategory

    func testSearchByCategory_vehicule_withSuccess() {
        let (presenter, interactorMock) = makeSUT(status: .success)

        presenter.searchByCategory(.vehicule)

        XCTAssertEqual(interactorMock.functionsCalled.count, 1)
        XCTAssertEqual(interactorMock.functionsCalled[0], searchByCategorySelectorName)
        XCTAssertEqual(viewMock.functionsCalled.count, 2)
        XCTAssertEqual(viewMock.functionsCalled[0], endLoadingIndicatorSelectorName)
        XCTAssertEqual(viewMock.functionsCalled[1], displaySearchResultSelectorName)
        XCTAssertEqual(viewMock.lastSearchType, .category)
        XCTAssertEqual(viewMock.lastSearchCategory, .vehicule)
    }

    func testSearchByCategory_realState_withSuccess() {
        let (presenter, interactorMock) = makeSUT(status: .success)

        presenter.searchByCategory(.realState)

        XCTAssertEqual(interactorMock.functionsCalled.first, searchByCategorySelectorName)
        XCTAssertEqual(viewMock.lastSearchCategory, .realState)
    }

    func testSearchByCategory_services_withSuccess() {
        let (presenter, interactorMock) = makeSUT(status: .success)

        presenter.searchByCategory(.services)

        XCTAssertEqual(interactorMock.functionsCalled.first, searchByCategorySelectorName)
        XCTAssertEqual(viewMock.lastSearchCategory, .services)
    }

    func testSearchByCategory_withHTTPError_callsRouterDisplayAlert() {
        let (presenter, _) = makeSUT(status: .failure)

        presenter.searchByCategory(.realState)

        XCTAssertTrue(viewMock.functionsCalled.contains(endLoadingIndicatorSelectorName))
        XCTAssertTrue(routerMock.functionsCalled.contains(displayAlertSelectorName))
        XCTAssertEqual(routerMock.lastAlertTitle, "Error")
        _ = presenter
    }

    func testSearchByCategory_publisherSendsGenericError_showsDifferentAlertTitle() {
        let (presenter, _) = makeSUT()

        publisher.send(.categorySearchedWithFailure(CloudDataSourceDefaultError.unwrappableValue))

        XCTAssertTrue(routerMock.functionsCalled.contains(displayAlertSelectorName))
        XCTAssertEqual(routerMock.lastAlertTitle, "Error en tu busqueda")
        _ = presenter
    }

    func testSearchByCategory_doesNotCallRouter_onSuccess() {
        let (presenter, _) = makeSUT(status: .success)

        presenter.searchByCategory(.services)

        XCTAssertTrue(routerMock.functionsCalled.isEmpty)
        _ = presenter
    }

    // MARK: - Tests: Publisher direct events

    func testPublisher_itemsSearchedWithSuccess_setsSearchTypeText() {
        let (presenter, _) = makeSUT()
        let mockResult = HomeMLCDataMock.homeSearchItem.searchDefaultResult!

        publisher.send(.itemsSearchedWithSuccess(searchResult: mockResult))

        XCTAssertEqual(viewMock.lastSearchType, .text)
        XCTAssertEqual(viewMock.lastSearchCategory, .none)
        _ = presenter
    }

    func testPublisher_categorySearchedWithSuccess_setsCorrectCategory() {
        let (presenter, _) = makeSUT()
        let mockResult = HomeMLCDataMock.homeSearchItem.searchDefaultResult!

        publisher.send(.categorySearchedWithSuccess(searchResult: mockResult, searchedCategory: .vehicule))

        XCTAssertEqual(viewMock.lastSearchType, .category)
        XCTAssertEqual(viewMock.lastSearchCategory, .vehicule)
        _ = presenter
    }

    func testPublisher_completionFinished_callsEndLoadingIndicator() {
        let (presenter, _) = makeSUT()

        publisher.send(completion: .finished)

        XCTAssertEqual(viewMock.functionsCalled.count, 1)
        XCTAssertEqual(viewMock.functionsCalled[0], endLoadingIndicatorSelectorName)
        _ = presenter
    }

    func testPublisher_completionFailure_callsEndLoadingAndRouterAlert() {
        let (presenter, _) = makeSUT()

        publisher.send(completion: .failure(CloudDataSourceDefaultError.httpError(code: 500, message: "Server Error")))

        XCTAssertTrue(viewMock.functionsCalled.contains(endLoadingIndicatorSelectorName))
        XCTAssertTrue(routerMock.functionsCalled.contains(displayAlertSelectorName))
        _ = presenter
    }

    // MARK: - Tests: presentSearchResult

    func testPresentSearchResult_text_callsRouter() {
        let (presenter, _) = makeSUT()
        let mockResult = HomeMLCDataMock.homeSearchItem.searchDefaultResult!

        presenter.presentSearchResult(mockResult, searchType: .text, searchCategory: .none)

        XCTAssertEqual(routerMock.functionsCalled.count, 1)
        XCTAssertEqual(routerMock.functionsCalled[0], presentSearchResultSelectorName)
    }

    func testPresentSearchResult_category_callsRouter() {
        let (presenter, _) = makeSUT()
        let mockResult = HomeMLCDataMock.homeSearchItem.searchDefaultResult!

        presenter.presentSearchResult(mockResult, searchType: .category, searchCategory: .realState)

        XCTAssertEqual(routerMock.functionsCalled.count, 1)
        XCTAssertEqual(routerMock.functionsCalled[0], presentSearchResultSelectorName)
    }

    // MARK: - Tests: Multiple searches

    func testMultipleSearchItems_callsInteractorMultipleTimes() {
        let (presenter, interactorMock) = makeSUT(status: .success)

        presenter.searchItem(searchText: "iPhone")
        presenter.searchItem(searchText: "Samsung")
        presenter.searchItem(searchText: "Xiaomi")

        XCTAssertEqual(interactorMock.functionsCalled.count, 3)
        XCTAssertTrue(interactorMock.functionsCalled.allSatisfy { $0 == self.serachItemSelectorName })
    }
}
