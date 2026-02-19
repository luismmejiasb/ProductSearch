import Foundation
import UIKit
@testable import ProductSearch

// MARK: - SearchResultViewMock

class SearchResultViewMock: SearchResultViewProtocol {
    // MARK: Properties

    var functionsCalled = [String]()
    var lastNextOffSetResult: SearchResult?
    var lastSearchType: SearchType?
    var lastSearchCategory: HomeCategorySearch?

    // MARK: Functions

    func displaySearchResult() {
        functionsCalled.append(#function)
    }

    func displayNextOffSetResult(
        _ nextOffSetResult: SearchResult,
        searchType: SearchType,
        searchCategory: HomeCategorySearch?
    ) {
        functionsCalled.append(#function)
        lastNextOffSetResult = nextOffSetResult
        lastSearchType = searchType
        lastSearchCategory = searchCategory
    }

    func endLoadingIndicator() {
        functionsCalled.append(#function)
    }
}
