import UIKit
import XCTest
@testable import ArtistSearch

// MARK: - SearchResultFactoryTests

@MainActor
class SearchResultFactoryTests: XCTestCase {
    // MARK: Helpers

    private var sampleSearchResult: ArtistSearchResult {
        SearchResultITunesDataMock.multipleResults.searchResult
    }

    // MARK: - Tests: text search type

    func testInitializeTextSearchReturnsViewController() {
        // when
        let viewController = SearchResultFactory.initialize(
            homeSearchResult: sampleSearchResult,
            searchType: .text,
            searchCategory: .none
        )
        // then
        XCTAssertNotNil(viewController)
    }

    func testInitializeTextSearchReturnsCorrectType() {
        // when
        let viewController = SearchResultFactory.initialize(
            homeSearchResult: sampleSearchResult,
            searchType: .text,
            searchCategory: .none
        )
        // then
        XCTAssertTrue(viewController is SearchResultViewController)
    }

    func testInitializeTextSearchPresenterIsSet() {
        // when
        let viewController = SearchResultFactory.initialize(
            homeSearchResult: sampleSearchResult,
            searchType: .text,
            searchCategory: .none
        )
        // then
        XCTAssertNotNil(viewController.presenter)
    }

    func testInitializeTextSearchPresenterHasCorrectSearchType() {
        // when
        let viewController = SearchResultFactory.initialize(
            homeSearchResult: sampleSearchResult,
            searchType: .text,
            searchCategory: .none
        )
        // then
        XCTAssertEqual(viewController.presenter?.getSearchType(), .text)
    }

    // MARK: - Tests: category search type

    func testInitializeCategorySearchPresenterHasCorrectSearchType() {
        // given
        let categoryResult = SearchResultITunesDataMock.multipleResults.searchResult
        // when
        let viewController = SearchResultFactory.initialize(
            homeSearchResult: categoryResult,
            searchType: .category,
            searchCategory: .reggaeton
        )
        // then
        XCTAssertEqual(viewController.presenter?.getSearchType(), .category)
    }

    func testInitializeCategorySearchPresenterHasCorrectCategory() {
        // given
        let categoryResult = SearchResultITunesDataMock.multipleResults.searchResult
        // when
        let viewController = SearchResultFactory.initialize(
            homeSearchResult: categoryResult,
            searchType: .category,
            searchCategory: .salsa
        )
        // then
        XCTAssertEqual(viewController.presenter?.getSearchCategory(), .salsa)
    }

    func testInitializeCategoryMusicPresenterHasMusicCategory() {
        // when
        let viewController = SearchResultFactory.initialize(
            homeSearchResult: sampleSearchResult,
            searchType: .category,
            searchCategory: .reggaeton
        )
        // then
        XCTAssertEqual(viewController.presenter?.getSearchCategory(), .reggaeton)
    }

    func testInitializeCategoryPodcastsPresenterHasPodcastsCategory() {
        // when
        let viewController = SearchResultFactory.initialize(
            homeSearchResult: sampleSearchResult,
            searchType: .category,
            searchCategory: .rock
        )
        // then
        XCTAssertEqual(viewController.presenter?.getSearchCategory(), .rock)
    }

    // MARK: - Tests: search result is set

    func testInitializePresenterSearchResultIsNotNil() {
        // when
        let viewController = SearchResultFactory.initialize(
            homeSearchResult: sampleSearchResult,
            searchType: .text,
            searchCategory: .none
        )
        // then
        XCTAssertNotNil(viewController.presenter?.getSearchResult())
    }

    func testInitializePresenterSearchResultMatchesInput() {
        // when
        let viewController = SearchResultFactory.initialize(
            homeSearchResult: sampleSearchResult,
            searchType: .text,
            searchCategory: .none
        )
        // then
        XCTAssertEqual(
            viewController.presenter?.getSearchResult()?.resultCount,
            sampleSearchResult.resultCount
        )
    }

    // MARK: - Tests: different instances

    func testInitializeCalledTwiceReturnsDifferentInstances() {
        // when
        let first = SearchResultFactory.initialize(
            homeSearchResult: sampleSearchResult,
            searchType: .text,
            searchCategory: .none
        )
        let second = SearchResultFactory.initialize(
            homeSearchResult: sampleSearchResult,
            searchType: .text,
            searchCategory: .none
        )
        // then
        XCTAssertFalse(first === second)
    }
}
