import Foundation
import UIKit
@testable import ProductSearch

class HomeRouterMock: HomeRouterProtocol {
    // MARK: Properties

    var view: HomeViewControllerProtocol?
    var functionsCalled = [String]()

    // MARK: Functions

    func presentSearchResult(_: SearchResult, searchType _: SearchType, searchCategory _: HomeCategorySearch?) {
        functionsCalled.append(#function)
    }

    func displayAlert(title _: String, message _: String) {
        functionsCalled.append(#function)
    }
}
