import Foundation
import UIKit
@testable import ProductSearch

// MARK: - ProductDetailRouterMock

class ProductDetailRouterMock: ProductDetailRouterProtocol {
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
