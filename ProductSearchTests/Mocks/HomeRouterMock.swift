import Foundation
import UIKit
@testable import ArtistSearch

class HomeRouterMock: HomeRouterProtocol {
    // MARK: Properties

    var view: HomeViewControllerProtocol?
    var functionsCalled = [String]()
    var lastAlertTitle: String = ""
    var lastAlertMessage: String = ""
    var lastSearchResult: ArtistSearchResult?
    var lastSearchType: SearchType?
    var lastSearchCategory: HomeCategorySearch?

    // MARK: Functions

    func presentSearchResult(_ searchResult: ArtistSearchResult, searchType: SearchType, searchCategory: HomeCategorySearch) {
        functionsCalled.append(#function)
        lastSearchResult = searchResult
        lastSearchType = searchType
        lastSearchCategory = searchCategory
    }

    func displayAlert(title: String, message: String) {
        functionsCalled.append(#function)
        lastAlertTitle = title
        lastAlertMessage = message
    }
}
