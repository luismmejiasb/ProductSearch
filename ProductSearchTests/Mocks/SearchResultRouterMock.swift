import Foundation
import UIKit
@testable import ProductSearch

// MARK: - SearchResultRouterMock

class SearchResultRouterMock: SearchResultRouterProtocol {
    // MARK: Properties

    var functionsCalled = [String]()
    var lastAlertTitle: String = ""
    var lastAlertMessage: String = ""
    var lastPresentedProduct: Result?

    // MARK: Functions

    func presentFilterTypeActionSheet() {
        functionsCalled.append(#function)
    }

    func presentProductDetail(_ result: Result) {
        functionsCalled.append(#function)
        lastPresentedProduct = result
    }

    func displayAlert(title: String, message: String) {
        functionsCalled.append(#function)
        lastAlertTitle = title
        lastAlertMessage = message
    }
}
