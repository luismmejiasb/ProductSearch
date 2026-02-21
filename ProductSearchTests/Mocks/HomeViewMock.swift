import Foundation
import UIKit
@testable import ArtistSearch

class HomeViewMock: UIViewController, HomeViewProtocol {
    // MARK: Properties

    var presenter: HomePresenterProtocol?
    var functionsCalled = [String]()

    // MARK: Functions

    func endLoadingIndicator() {
        functionsCalled.append(#function)
    }
}
