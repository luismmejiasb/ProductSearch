import XCTest
@testable import ArtistSearch

// MARK: - ArtistDetailPresenterTests

@MainActor
class ArtistDetailPresenterTests: XCTestCase {
    // MARK: Properties

    private var viewMock: ArtistDetailViewMock!
    private var routerMock: ArtistDetailRouterMock!
    private var interactorMock: ArtistDetailInteractorMock!

    // MARK: Selector constants

    private let displayArtistDetailSelectorName = "displayArtistDetail(_:)"

    // MARK: Lifecycle

    override func setUp() {
        super.setUp()
        viewMock = ArtistDetailViewMock()
        routerMock = ArtistDetailRouterMock()
        interactorMock = ArtistDetailInteractorMock()
    }

    override func tearDown() {
        viewMock = nil
        routerMock = nil
        interactorMock = nil
        super.tearDown()
    }

    // MARK: Helpers

    private func makeArtist(
        artistName: String = "Jack Johnson",
        trackPrice: Double = 1.29,
        primaryGenreName: String = "Rock",
        trackId: Int = 201281527
    ) -> ArtistResult {
        ArtistResult(
            wrapperType: "track",
            kind: "song",
            artistId: 909253,
            collectionId: nil,
            trackId: trackId,
            artistName: artistName,
            collectionName: "Curious George",
            trackName: "Upside Down",
            collectionCensoredName: nil,
            trackCensoredName: nil,
            artistViewUrl: nil,
            collectionViewUrl: nil,
            trackViewUrl: nil,
            previewUrl: nil,
            artworkUrl60: nil,
            artworkUrl100: nil,
            collectionPrice: 9.99,
            trackPrice: trackPrice,
            collectionExplicitness: nil,
            trackExplicitness: nil,
            discCount: nil,
            discNumber: nil,
            trackCount: nil,
            trackNumber: nil,
            trackTimeMillis: 208643,
            country: "USA",
            currency: "USD",
            primaryGenreName: primaryGenreName
        )
    }

    private func makeSUT(artist: ArtistResult) -> ArtistDetailPresenter {
        let presenter = ArtistDetailPresenter(
            interactor: interactorMock,
            router: routerMock,
            artist: artist
        )
        presenter.view = viewMock
        return presenter
    }

    // MARK: - Tests: displayArtistDetail

    func testDisplayArtistDetailCallsViewMethod() {
        // given
        let artist = makeArtist()
        let presenter = makeSUT(artist: artist)

        // when
        presenter.displayArtistDetail()

        // then
        XCTAssertEqual(viewMock.functionsCalled.count, 1)
        XCTAssertEqual(viewMock.functionsCalled[0], displayArtistDetailSelectorName)
    }

    func testDisplayArtistDetailPassesCorrectArtistName() {
        // given
        let artist = makeArtist(artistName: "Coldplay")
        let presenter = makeSUT(artist: artist)

        // when
        presenter.displayArtistDetail()

        // then
        XCTAssertEqual(viewMock.receivedArtist?.artistName, "Coldplay")
    }

    func testDisplayArtistDetailPassesCorrectTrackPrice() {
        // given
        let artist = makeArtist(trackPrice: 1.49)
        let presenter = makeSUT(artist: artist)

        // when
        presenter.displayArtistDetail()

        // then
        XCTAssertEqual(viewMock.receivedArtist?.trackPrice, 1.49)
    }

    func testDisplayArtistDetailPassesCorrectGenre() {
        // given
        let artist = makeArtist(primaryGenreName: "Alternative")
        let presenter = makeSUT(artist: artist)

        // when
        presenter.displayArtistDetail()

        // then
        XCTAssertEqual(viewMock.receivedArtist?.primaryGenreName, "Alternative")
    }

    func testDisplayArtistDetailPassesCorrectTrackId() {
        // given
        let artist = makeArtist(trackId: 300001)
        let presenter = makeSUT(artist: artist)

        // when
        presenter.displayArtistDetail()

        // then
        XCTAssertEqual(viewMock.receivedArtist?.trackId, 300001)
    }

    func testDisplayArtistDetailCalledMultipleTimesCallsViewEachTime() {
        // given
        let artist = makeArtist()
        let presenter = makeSUT(artist: artist)

        // when
        presenter.displayArtistDetail()
        presenter.displayArtistDetail()
        presenter.displayArtistDetail()

        // then
        XCTAssertEqual(viewMock.functionsCalled.count, 3)
        XCTAssertTrue(viewMock.functionsCalled.allSatisfy { $0 == self.displayArtistDetailSelectorName })
    }

    func testDisplayArtistDetailWithNilViewDoesNotCrash() {
        // given
        let artist = makeArtist()
        let presenter = ArtistDetailPresenter(
            interactor: interactorMock,
            router: routerMock,
            artist: artist
        )
        presenter.view = nil

        // when
        presenter.displayArtistDetail()

        // then (should not crash, view is simply not called)
        XCTAssertTrue(viewMock.functionsCalled.isEmpty)
    }

    func testDisplayArtistDetailDoesNotCallRouter() {
        // given
        let artist = makeArtist()
        let presenter = makeSUT(artist: artist)

        // when
        presenter.displayArtistDetail()

        // then
        XCTAssertTrue(routerMock.functionsCalled.isEmpty)
    }

    func testDisplayArtistDetailDoesNotCallInteractor() {
        // given
        let artist = makeArtist()
        let presenter = makeSUT(artist: artist)

        // when
        presenter.displayArtistDetail()

        // then
        XCTAssertTrue(interactorMock.functionsCalled.isEmpty)
    }
}
