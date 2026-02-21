import Foundation
import UIKit
@testable import ArtistSearch

// MARK: - SearchResultViewMock

class SearchResultViewMock: SearchResultViewProtocol {
    // MARK: Properties

    var functionsCalled = [String]()
    var lastNextPageResult: ArtistSearchResult?
    var lastSearchType: SearchType?
    var lastSearchCategory: HomeCategorySearch?

    // MARK: Functions

    func displaySearchResult() {
        functionsCalled.append(#function)
    }

    func displayNextPageResult(
        _ nextPageResult: ArtistSearchResult,
        searchType: SearchType,
        searchCategory: HomeCategorySearch?
    ) {
        functionsCalled.append(#function)
        lastNextPageResult = nextPageResult
        lastSearchType = searchType
        lastSearchCategory = searchCategory
    }

    func endLoadingIndicator() {
        functionsCalled.append(#function)
    }
}
