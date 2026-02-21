import Foundation
@testable import ArtistSearch

class HomePresenterMock: HomePresenterProtocol {
    // MARK: Properties

    var functionsCalled = [String]()
    var lastSearchText: String = ""
    var lastCategory: HomeCategorySearch = .none

    // MARK: Functions

    func viewDidLoad() {
        functionsCalled.append(#function)
    }

    func searchArtist(searchText: String) {
        functionsCalled.append(#function)
        lastSearchText = searchText
    }

    func searchByCategory(_ category: HomeCategorySearch) {
        functionsCalled.append(#function)
        lastCategory = category
    }
}
