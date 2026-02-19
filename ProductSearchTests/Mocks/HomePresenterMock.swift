import Foundation
@testable import ProductSearch

class HomePresenterMock: HomePresenterProtocol {
    // MARK: Properties

    var functionsCalled = [String]()
    var lastSearchText: String = ""
    var lastCategory: HomeCategorySearch = .none

    // MARK: Functions

    func viewDidLoad() {
        functionsCalled.append(#function)
    }

    func searchItem(searchText: String) {
        functionsCalled.append(#function)
        lastSearchText = searchText
    }

    func searchByCategory(_ category: HomeCategorySearch) {
        functionsCalled.append(#function)
        lastCategory = category
    }

    func presentSearchResult(_: SearchResult, searchType _: SearchType, searchCategory _: HomeCategorySearch) {
        functionsCalled.append(#function)
    }
}
