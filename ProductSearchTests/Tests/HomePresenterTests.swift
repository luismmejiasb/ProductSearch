import Combine
import XCTest
@testable import ArtistSearch

// MARK: - HomePresenterTests

@MainActor
class HomePresenterTests: XCTestCase {
    // MARK: Properties

    private var viewMock: HomeViewMock!
    private var routerMock: HomeRouterMock!
    private var publisher: PassthroughSubject<HomePublisherResult, Error>!
    private var searchTokens = Set<AnyCancellable>()

    // MARK: Selector constants

    private let searchArtistSelectorName = "searchArtist(searchText:)"
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
        let interactorMock = HomeInteractorMock(repository: repositoryMock, publisher: publisher)
        let presenter = HomePresenter(interactor: interactorMock, router: routerMock)
        presenter.view = viewMock
        presenter.viewDidLoad()
        return (presenter, interactorMock)
    }

    // MARK: - Tests: searchArtist

    func testSearchArtistWithSuccessCallsInteractorAndView() {
        // given
        let (presenter, interactorMock) = makeSUT(status: .success)

        // when
        presenter.searchArtist(searchText: "Jack Johnson")

        // then
        XCTAssertEqual(interactorMock.functionsCalled.count, 1)
        XCTAssertEqual(interactorMock.functionsCalled[0], searchArtistSelectorName)
        XCTAssertTrue(viewMock.functionsCalled.contains(endLoadingIndicatorSelectorName))
        XCTAssertTrue(routerMock.functionsCalled.contains(presentSearchResultSelectorName))
    }

    func testSearchArtistWithSuccessSearchResultIsNotNil() {
        // given
        let (presenter, _) = makeSUT(status: .success)

        // when
        presenter.searchArtist(searchText: "Jack Johnson")

        // then
        XCTAssertNotNil(routerMock.lastSearchResult)
    }

    func testSearchArtistWithHTTPErrorCallsRouterDisplayAlert() {
        // given
        let (presenter, interactorMock) = makeSUT(status: .failure)

        // when
        presenter.searchArtist(searchText: "Jack Johnson")

        // then
        XCTAssertEqual(interactorMock.functionsCalled.first, searchArtistSelectorName)
        XCTAssertTrue(viewMock.functionsCalled.contains(endLoadingIndicatorSelectorName))
        XCTAssertTrue(routerMock.functionsCalled.contains(displayAlertSelectorName))
        XCTAssertEqual(routerMock.lastAlertTitle, "Error")
        XCTAssertFalse(routerMock.lastAlertMessage.isEmpty)
    }

    func testSearchArtistWithHTTPErrorDoesNotCallPresentSearchResult() {
        // given
        let (presenter, _) = makeSUT(status: .failure)

        // when
        presenter.searchArtist(searchText: "Jack Johnson")

        // then
        XCTAssertFalse(routerMock.functionsCalled.contains(presentSearchResultSelectorName))
        _ = presenter
    }

    func testSearchArtistPublisherSendsGenericErrorShowsDifferentAlertTitle() {
        // given
        let (presenter, _) = makeSUT()

        // when
        publisher.send(.itemsSearchedWithFailure(CloudDataSourceDefaultError.responseCannotBeParsed))

        // then
        XCTAssertTrue(routerMock.functionsCalled.contains(displayAlertSelectorName))
        XCTAssertEqual(routerMock.lastAlertTitle, "Error en tu busqueda")
        _ = presenter
    }

    func testSearchArtistWithSuccessDoesNotCallRouterDisplayAlert() {
        // given
        let (presenter, _) = makeSUT(status: .success)

        // when
        presenter.searchArtist(searchText: "Jack Johnson")

        // then
        XCTAssertFalse(routerMock.functionsCalled.contains(displayAlertSelectorName))
        _ = presenter
    }

    // MARK: - Tests: searchByCategory

    func testSearchByCategoryMusicWithSuccess() {
        // given
        let (presenter, interactorMock) = makeSUT(status: .success)

        // when
        presenter.searchByCategory(.reggaeton)

        // then
        XCTAssertEqual(interactorMock.functionsCalled.count, 1)
        XCTAssertEqual(interactorMock.functionsCalled[0], searchByCategorySelectorName)
        XCTAssertTrue(viewMock.functionsCalled.contains(endLoadingIndicatorSelectorName))
        XCTAssertTrue(routerMock.functionsCalled.contains(presentSearchResultSelectorName))
    }

    func testSearchByCategoryMoviesWithSuccess() {
        // given
        let (presenter, interactorMock) = makeSUT(status: .success)

        // when
        presenter.searchByCategory(.salsa)

        // then
        XCTAssertEqual(interactorMock.functionsCalled.first, searchByCategorySelectorName)
    }

    func testSearchByCategoryPodcastsWithSuccess() {
        // given
        let (presenter, interactorMock) = makeSUT(status: .success)

        // when
        presenter.searchByCategory(.rock)

        // then
        XCTAssertEqual(interactorMock.functionsCalled.first, searchByCategorySelectorName)
    }

    func testSearchByCategoryWithHTTPErrorCallsRouterDisplayAlert() {
        // given
        let (presenter, _) = makeSUT(status: .failure)

        // when
        presenter.searchByCategory(.reggaeton)

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

    func testSearchByCategoryWithSuccessDoesNotCallRouterDisplayAlert() {
        // given
        let (presenter, _) = makeSUT(status: .success)

        // when
        presenter.searchByCategory(.rock)

        // then
        XCTAssertFalse(routerMock.functionsCalled.contains(displayAlertSelectorName))
        _ = presenter
    }

    // MARK: - Tests: Publisher direct events

    func testPublisherItemsSearchedWithSuccessSetsSearchTypeText() {
        // given
        let (presenter, _) = makeSUT()
        let mockResult = HomeITunesDataMock.homeSearchArtist.searchDefaultResult

        // when
        publisher.send(.itemsSearchedWithSuccess(searchResult: mockResult))

        // then
        XCTAssertEqual(routerMock.lastSearchType, .text)
        _ = presenter
    }

    func testPublisherCategorySearchedWithSuccessSetsCorrectCategory() {
        // given
        let (presenter, _) = makeSUT()
        let mockResult = HomeITunesDataMock.homeSearchArtist.searchDefaultResult

        // when
        publisher.send(.categorySearchedWithSuccess(searchResult: mockResult, searchedCategory: .reggaeton))

        // then
        XCTAssertEqual(routerMock.lastSearchType, .category)
        XCTAssertEqual(routerMock.lastSearchCategory, .reggaeton)
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

    // MARK: - Tests: Multiple searches

    func testMultipleSearchArtistCallsInteractorMultipleTimes() {
        // given
        let (presenter, interactorMock) = makeSUT(status: .success)

        // when
        presenter.searchArtist(searchText: "Jack Johnson")
        presenter.searchArtist(searchText: "Coldplay")
        presenter.searchArtist(searchText: "Adele")

        // then
        XCTAssertEqual(interactorMock.functionsCalled.count, 3)
        XCTAssertTrue(interactorMock.functionsCalled.allSatisfy { $0 == self.searchArtistSelectorName })
    }
}
