import UIKit
import XCTest
@testable import ProductSearch

// MARK: - SearchResultFactoryTests

@MainActor
class SearchResultFactoryTests: XCTestCase {
    // MARK: Helpers

    private var sampleSearchResult: SearchResult {
        SearchResultMLCDataMock.multipleResults.searchResult!
    }

    // MARK: - Tests: text search type

    func testInitialize_textSearch_returnsViewController() {
        let viewController = SearchResultFactory.initialize(
            homeSearchResult: sampleSearchResult,
            searchType: .text,
            searchCategory: .none
        )
        XCTAssertNotNil(viewController)
    }

    func testInitialize_textSearch_returnsCorrectType() {
        let viewController = SearchResultFactory.initialize(
            homeSearchResult: sampleSearchResult,
            searchType: .text,
            searchCategory: .none
        )
        XCTAssertTrue(viewController is SearchResultViewController)
    }

    func testInitialize_textSearch_presenterIsSet() {
        let viewController = SearchResultFactory.initialize(
            homeSearchResult: sampleSearchResult,
            searchType: .text,
            searchCategory: .none
        )
        XCTAssertNotNil(viewController.presenter)
    }

    func testInitialize_textSearch_presenterHasCorrectSearchType() {
        let viewController = SearchResultFactory.initialize(
            homeSearchResult: sampleSearchResult,
            searchType: .text,
            searchCategory: .none
        )
        XCTAssertEqual(viewController.presenter?.getSearchType(), .text)
    }

    // MARK: - Tests: category search type

    func testInitialize_categorySearch_presenterHasCorrectSearchType() {
        let categoryResult = SearchResultMLCDataMock.categoryResults.searchResult!
        let viewController = SearchResultFactory.initialize(
            homeSearchResult: categoryResult,
            searchType: .category,
            searchCategory: .vehicule
        )
        XCTAssertEqual(viewController.presenter?.getSearchType(), .category)
    }

    func testInitialize_categorySearch_presenterHasCorrectCategory() {
        let categoryResult = SearchResultMLCDataMock.categoryResults.searchResult!
        let viewController = SearchResultFactory.initialize(
            homeSearchResult: categoryResult,
            searchType: .category,
            searchCategory: .realState
        )
        XCTAssertEqual(viewController.presenter?.getSearchCategory(), .realState)
    }

    func testInitialize_categoryVehicule_presenterHasVehiculeCategory() {
        let viewController = SearchResultFactory.initialize(
            homeSearchResult: sampleSearchResult,
            searchType: .category,
            searchCategory: .vehicule
        )
        XCTAssertEqual(viewController.presenter?.getSearchCategory(), .vehicule)
    }

    func testInitialize_categoryServices_presenterHasServicesCategory() {
        let viewController = SearchResultFactory.initialize(
            homeSearchResult: sampleSearchResult,
            searchType: .category,
            searchCategory: .services
        )
        XCTAssertEqual(viewController.presenter?.getSearchCategory(), .services)
    }

    // MARK: - Tests: search result is set

    func testInitialize_presenterSearchResultIsNotNil() {
        let viewController = SearchResultFactory.initialize(
            homeSearchResult: sampleSearchResult,
            searchType: .text,
            searchCategory: .none
        )
        XCTAssertNotNil(viewController.presenter?.getSearchResult())
    }

    func testInitialize_presenterSearchResultMatchesInput() {
        let viewController = SearchResultFactory.initialize(
            homeSearchResult: sampleSearchResult,
            searchType: .text,
            searchCategory: .none
        )
        XCTAssertEqual(
            viewController.presenter?.getSearchResult()?.siteID,
            sampleSearchResult.siteID
        )
    }

    // MARK: - Tests: different instances

    func testInitialize_calledTwice_returnsDifferentInstances() {
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
        XCTAssertFalse(first === second)
    }
}
