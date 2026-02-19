import UIKit
import XCTest
@testable import ProductSearch

// MARK: - SearchResultFactoryTests

@MainActor
class SearchResultFactoryTests: XCTestCase {
    // MARK: Helpers

    private var sampleSearchResult: SearchResult {
        SearchResultMLCDataMock.multipleResults.searchResult
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
        let categoryResult = SearchResultMLCDataMock.categoryResults.searchResult
        // when
        let viewController = SearchResultFactory.initialize(
            homeSearchResult: categoryResult,
            searchType: .category,
            searchCategory: .vehicule
        )
        // then
        XCTAssertEqual(viewController.presenter?.getSearchType(), .category)
    }

    func testInitializeCategorySearchPresenterHasCorrectCategory() {
        // given
        let categoryResult = SearchResultMLCDataMock.categoryResults.searchResult
        // when
        let viewController = SearchResultFactory.initialize(
            homeSearchResult: categoryResult,
            searchType: .category,
            searchCategory: .realState
        )
        // then
        XCTAssertEqual(viewController.presenter?.getSearchCategory(), .realState)
    }

    func testInitializeCategoryVehiculePresenterHasVehiculeCategory() {
        // when
        let viewController = SearchResultFactory.initialize(
            homeSearchResult: sampleSearchResult,
            searchType: .category,
            searchCategory: .vehicule
        )
        // then
        XCTAssertEqual(viewController.presenter?.getSearchCategory(), .vehicule)
    }

    func testInitializeCategoryServicesPresenterHasServicesCategory() {
        // when
        let viewController = SearchResultFactory.initialize(
            homeSearchResult: sampleSearchResult,
            searchType: .category,
            searchCategory: .services
        )
        // then
        XCTAssertEqual(viewController.presenter?.getSearchCategory(), .services)
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
            viewController.presenter?.getSearchResult()?.siteID,
            sampleSearchResult.siteID
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
