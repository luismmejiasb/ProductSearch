import UIKit
import XCTest
@testable import ArtistSearch

// MARK: - ArtistDetailFactoryTests

@MainActor
class ArtistDetailFactoryTests: XCTestCase {
    // MARK: Helpers

    private var sampleArtist: ArtistResult {
        guard let artist = SearchResultITunesDataMock.multipleResults.searchResult.results?.first else {
            fatalError("ArtistDetailFactoryTests: sampleArtist — results array is empty or nil in mock data")
        }
        return artist
    }

    // MARK: - Tests: Factory initialization

    func testInitializeReturnsViewController() {
        // when
        let viewController = ArtistDetailFactory.initialize(artist: sampleArtist)

        // then
        XCTAssertNotNil(viewController)
    }

    func testInitializeReturnsCorrectType() {
        // when
        let viewController = ArtistDetailFactory.initialize(artist: sampleArtist)

        // then
        XCTAssertTrue(viewController is ArtistDetailViewController)
    }

    func testInitializePresenterIsSet() {
        // when
        let viewController = ArtistDetailFactory.initialize(artist: sampleArtist)

        // then
        XCTAssertNotNil(viewController.presenter)
    }

    func testInitializeCallingTwiceReturnsDifferentInstances() {
        // when
        let first = ArtistDetailFactory.initialize(artist: sampleArtist)
        let second = ArtistDetailFactory.initialize(artist: sampleArtist)

        // then
        XCTAssertFalse(first === second)
    }
}
