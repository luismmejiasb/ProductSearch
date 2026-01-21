import Foundation
@testable import ProductSearch

class HomeViewMock: HomeViewControllerProtocol {
    // MARK: Properties

    var presenter: HomePresenterProtocol?
    var functionsCalled = [String]()

    // MARK: Functions

    func displaySearchResult(_: SearchResult, searchType _: SearchType, searchCategory _: HomeCategorySearch?) {
        functionsCalled.append(#function)
    }

    func endLoadingIndicator() {
        functionsCalled.append(#function)
    }
}
