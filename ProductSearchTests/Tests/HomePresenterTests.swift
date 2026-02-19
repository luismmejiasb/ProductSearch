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

    func testSearchItemWithSuccessCallsInteractorAndView() {
        // given
        let (presenter, interactorMock) = makeSUT(status: .success)

        // when
        presenter.searchItem(searchText: "iPhone")

        // then
        XCTAssertEqual(interactorMock.functionsCalled.count, 1)
        XCTAssertEqual(interactorMock.functionsCalled[0], serachItemSelectorName)
        XCTAssertEqual(viewMock.functionsCalled.count, 2)
        XCTAssertEqual(viewMock.functionsCalled[0], endLoadingIndicatorSelectorName)
        XCTAssertEqual(viewMock.functionsCalled[1], displaySearchResultSelectorName)
        XCTAssertEqual(viewMock.lastSearchType, .text)
    }

    func testSearchItemWithSuccessSearchResultIsNotNil() {
        // given
        let (presenter, _) = makeSUT(status: .success)

        // when
        presenter.searchItem(searchText: "iPod Nano")

        // then
        XCTAssertNotNil(viewMock.lastSearchResult)
    }

    func testSearchItemWithHTTPErrorCallsRouterDisplayAlert() {
        // given
        let (presenter, interactorMock) = makeSUT(status: .failure)

        // when
        presenter.searchItem(searchText: "iPhone")

        // then
        XCTAssertEqual(interactorMock.functionsCalled.first, serachItemSelectorName)
        XCTAssertTrue(viewMock.functionsCalled.contains(endLoadingIndicatorSelectorName))
        XCTAssertTrue(routerMock.functionsCalled.contains(displayAlertSelectorName))
        XCTAssertEqual(routerMock.lastAlertTitle, "Error")
        XCTAssertFalse(routerMock.lastAlertMessage.isEmpty)
    }

    func testSearchItemWithHTTPErrorDoesNotCallDisplaySearchResult() {
        // given
        let (presenter, _) = makeSUT(status: .failure)

        // when
        presenter.searchItem(searchText: "iPhone")

        // then
        XCTAssertFalse(viewMock.functionsCalled.contains(displaySearchResultSelectorName))
        _ = presenter
    }

    func testSearchItemPublisherSendsGenericErrorShowsDifferentAlertTitle() {
        // given
        let (presenter, _) = makeSUT()

        // when
        publisher.send(.itemsSearchedWithFailure(CloudDataSourceDefaultError.responseCannotBeParsed))

        // then
        XCTAssertTrue(routerMock.functionsCalled.contains(displayAlertSelectorName))
        XCTAssertEqual(routerMock.lastAlertTitle, "Error en tu busqueda")
        _ = presenter
    }

    func testSearchItemDoesNotCallRouterOnSuccess() {
        // given
        let (presenter, _) = makeSUT(status: .success)

        // when
        presenter.searchItem(searchText: "iPhone")

        // then
        XCTAssertTrue(routerMock.functionsCalled.isEmpty)
        _ = presenter
    }

    // MARK: - Tests: searchByCategory

    func testSearchByCategoryVehiculeWithSuccess() {
        // given
        let (presenter, interactorMock) = makeSUT(status: .success)

        // when
        presenter.searchByCategory(.vehicule)

        // then
        XCTAssertEqual(interactorMock.functionsCalled.count, 1)
        XCTAssertEqual(interactorMock.functionsCalled[0], searchByCategorySelectorName)
        XCTAssertEqual(viewMock.functionsCalled.count, 2)
        XCTAssertEqual(viewMock.functionsCalled[0], endLoadingIndicatorSelectorName)
        XCTAssertEqual(viewMock.functionsCalled[1], displaySearchResultSelectorName)
    }

    func testSearchByCategoryRealStateWithSuccess() {
        // given
        let (presenter, interactorMock) = makeSUT(status: .success)

        // when
        presenter.searchByCategory(.realState)

        // then
        XCTAssertEqual(interactorMock.functionsCalled.first, searchByCategorySelectorName)
    }

    func testSearchByCategoryServicesWithSuccess() {
        // given
        let (presenter, interactorMock) = makeSUT(status: .success)

        // when
        presenter.searchByCategory(.services)

        // then
        XCTAssertEqual(interactorMock.functionsCalled.first, searchByCategorySelectorName)
    }

    func testSearchByCategoryWithHTTPErrorCallsRouterDisplayAlert() {
        // given
        let (presenter, _) = makeSUT(status: .failure)

        // when
        presenter.searchByCategory(.realState)

        // then
        XCTAssertTrue(viewMock.functionsCalled.contains(endLoadingIndicatorSelectorName))
        XCTAssertTrue(routerMock.functionsCalled.contains(displayAlertSelectorName))
        XCTAssertEqual(routerMock.lastAlertTitle, "Error")
        _ = presenter
    }

    func testSearchByCategoryPublisherSendsGenericErrorShowsDifferentAlertTitle() {
        // given
        let (presenter, _) = makeSUT()

        // when
        publisher.send(.categorySearchedWithFailure(CloudDataSourceDefaultError.unwrappableValue))

        // then
        XCTAssertTrue(routerMock.functionsCalled.contains(displayAlertSelectorName))
        XCTAssertEqual(routerMock.lastAlertTitle, "Error en tu busqueda")
        _ = presenter
    }

    func testSearchByCategoryDoesNotCallRouterOnSuccess() {
        // given
        let (presenter, _) = makeSUT(status: .success)

        // when
        presenter.searchByCategory(.services)

        // then
        XCTAssertTrue(routerMock.functionsCalled.isEmpty)
        _ = presenter
    }

    // MARK: - Tests: Publisher direct events

    func testPublisherItemsSearchedWithSuccessSetsSearchTypeText() {
        // given
        let (presenter, _) = makeSUT()
        let mockResult = HomeMLCDataMock.homeSearchItem.searchDefaultResult

        // when
        publisher.send(.itemsSearchedWithSuccess(searchResult: mockResult))

        // then
        XCTAssertEqual(viewMock.lastSearchType, .text)
        _ = presenter
    }

    func testPublisherCategorySearchedWithSuccessSetsCorrectCategory() {
        // given
        let (presenter, _) = makeSUT()
        let mockResult = HomeMLCDataMock.homeSearchItem.searchDefaultResult

        // when
        publisher.send(.categorySearchedWithSuccess(searchResult: mockResult, searchedCategory: .vehicule))

        // then
        XCTAssertEqual(viewMock.lastSearchType, .category)
        XCTAssertEqual(viewMock.lastSearchCategory, .vehicule)
        _ = presenter
    }

    func testPublisherCompletionFinishedCallsEndLoadingIndicator() {
        // given
        let (presenter, _) = makeSUT()

        // when
        publisher.send(completion: .finished)

        // then
        XCTAssertEqual(viewMock.functionsCalled.count, 1)
        XCTAssertEqual(viewMock.functionsCalled[0], endLoadingIndicatorSelectorName)
        _ = presenter
    }

    func testPublisherCompletionFailureCallsEndLoadingAndRouterAlert() {
        // given
        let (presenter, _) = makeSUT()

        // when
        publisher.send(completion: .failure(CloudDataSourceDefaultError.httpError(code: 500, message: "Server Error")))

        // then
        XCTAssertTrue(viewMock.functionsCalled.contains(endLoadingIndicatorSelectorName))
        XCTAssertTrue(routerMock.functionsCalled.contains(displayAlertSelectorName))
        _ = presenter
    }

    // MARK: - Tests: presentSearchResult

    func testPresentSearchResultTextCallsRouter() {
        // given
        let (presenter, _) = makeSUT()
        let mockResult = HomeMLCDataMock.homeSearchItem.searchDefaultResult

        // when
        presenter.presentSearchResult(mockResult, searchType: .text, searchCategory: .none)

        // then
        XCTAssertEqual(routerMock.functionsCalled.count, 1)
        XCTAssertEqual(routerMock.functionsCalled[0], presentSearchResultSelectorName)
    }

    func testPresentSearchResultCategoryCallsRouter() {
        // given
        let (presenter, _) = makeSUT()
        let mockResult = HomeMLCDataMock.homeSearchItem.searchDefaultResult

        // when
        presenter.presentSearchResult(mockResult, searchType: .category, searchCategory: .realState)

        // then
        XCTAssertEqual(routerMock.functionsCalled.count, 1)
        XCTAssertEqual(routerMock.functionsCalled[0], presentSearchResultSelectorName)
    }

    // MARK: - Tests: Multiple searches

    func testMultipleSearchItemsCallsInteractorMultipleTimes() {
        // given
        let (presenter, interactorMock) = makeSUT(status: .success)

        // when
        presenter.searchItem(searchText: "iPhone")
        presenter.searchItem(searchText: "Samsung")
        presenter.searchItem(searchText: "Xiaomi")

        // then
        XCTAssertEqual(interactorMock.functionsCalled.count, 3)
        XCTAssertTrue(interactorMock.functionsCalled.allSatisfy { $0 == self.serachItemSelectorName })
    }
}
