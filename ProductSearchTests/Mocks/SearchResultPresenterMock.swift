import Foundation
@testable import ProductSearch

// MARK: - SearchResultPresenterMock

class SearchResultPresenterMock: SearchResultPresenterProtocol {
    // MARK: Properties

    var functionsCalled = [String]()
    var searchResult: SearchResult?
    var searchType: SearchType = .text
    var searchCategory: HomeCategorySearch = .none

    // MARK: Functions

    func viewDidLoad() {
        functionsCalled.append(#function)
    }

    func presentFilterTypeActionSheet() {
        functionsCalled.append(#function)
    }

    func fetchNextOffSet() {
        functionsCalled.append(#function)
    }

    func presentProductDetail(_ result: Result) {
        functionsCalled.append(#function)
    }

    func getSearchResult() -> SearchResult? {
        functionsCalled.append(#function)
        return searchResult
    }

    func setSearchResult(results: [Result]?) {
        functionsCalled.append(#function)
        searchResult?.results = results
    }

    func getSearchType() -> SearchType {
        functionsCalled.append(#function)
        return searchType
    }

    func getSearchCategory() -> HomeCategorySearch {
        functionsCalled.append(#function)
        return searchCategory
    }
}
