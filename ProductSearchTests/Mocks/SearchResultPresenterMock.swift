import Foundation
@testable import ArtistSearch

// MARK: - SearchResultPresenterMock

class SearchResultPresenterMock: SearchResultPresenterProtocol {
    // MARK: Properties

    var functionsCalled = [String]()
    var searchResult: ArtistSearchResult?
    var searchType: SearchType = .text
    var searchCategory: HomeCategorySearch = .none

    // MARK: Functions

    func viewDidLoad() {
        functionsCalled.append(#function)
    }

    func presentFilterTypeActionSheet() {
        functionsCalled.append(#function)
    }

    func fetchNextPage() {
        functionsCalled.append(#function)
    }

    func presentArtistDetail(_ result: ArtistResult) {
        functionsCalled.append(#function)
    }

    func getSearchResult() -> ArtistSearchResult? {
        functionsCalled.append(#function)
        return searchResult
    }

    func setSearchResult(results: [ArtistResult]?) {
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
