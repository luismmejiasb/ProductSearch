import Foundation
import UIKit
@testable import ArtistSearch

// MARK: - SearchResultRouterMock

class SearchResultRouterMock: SearchResultRouterProtocol {
    // MARK: Properties

    var functionsCalled = [String]()
    var lastAlertTitle: String = ""
    var lastAlertMessage: String = ""
    var lastPresentedArtist: ArtistResult?

    // MARK: Functions

    func presentFilterTypeActionSheet() {
        functionsCalled.append(#function)
    }

    func presentArtistDetail(_ result: ArtistResult) {
        functionsCalled.append(#function)
        lastPresentedArtist = result
    }

    func displayAlert(title: String, message: String) {
        functionsCalled.append(#function)
        lastAlertTitle = title
        lastAlertMessage = message
    }
}
