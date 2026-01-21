import Foundation
@testable import ProductSearch

class HomePresenterMock: HomePresenterProtocol {
    // MARK: Properties

    var interactor: HomeInteractorProtocol?
    var router: HomeRouterProtocol?
    var view: HomeViewControllerProtocol?
    var functionsCalled = [String]()

    // MARK: Functions

    func viewDidLoad() {
        functionsCalled.append(#function)
    }

    func searchItem(searchText _: String) {
        functionsCalled.append(#function)
    }

    func searchByCategory(_: HomeCategorySearch) {
        functionsCalled.append(#function)
    }

    func presentSearchResult(_: SearchResult, searchType _: SearchType, searchCategory _: HomeCategorySearch?) {
        functionsCalled.append(#function)
    }
}
