import Foundation
import UIKit
@testable import ArtistSearch

// MARK: - ArtistDetailRouterMock

class ArtistDetailRouterMock: ArtistDetailRouterProtocol {
    // MARK: Properties

    var view: UIViewController?
    var functionsCalled = [String]()
    var lastAlertTitle: String = ""
    var lastAlertMessage: String = ""

    // MARK: Functions

    func displayAlert(title: String, message: String) {
        functionsCalled.append(#function)
        lastAlertTitle = title
        lastAlertMessage = message
    }
}
