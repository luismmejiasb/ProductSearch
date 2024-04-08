//
//  HomeRouterMock.swift
//  Alamofire
//
//  Created by Luis Mejias on 22-03-22.
//

import Foundation
@testable import ProductSearch
import UIKit

class HomeRouterMock: HomeRouterProtocol {
    var view: HomeViewControllerProtocol?
    var functionsCalled = [String]()

    func presentSearchResult(_: SearchResult, searchType _: SearchType, searchCategory _: HomeCategorySearch?) {
        functionsCalled.append(#function)
    }

    func displayAlert(title _: String, message _: String) {
        functionsCalled.append(#function)
    }
}
