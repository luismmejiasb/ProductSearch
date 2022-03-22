//
//  HomeRouterMock.swift
//  Alamofire
//
//  Created by Luis Mejias on 22-03-22.
//

import Foundation
import UIKit
@testable import ProductSearch

class HomeRouterMock: HomeRouterProtocol {
    var view: HomeViewControllerProtocol?
    var functionsCalled = [String]()
    
    func presentSearchResult(_ searchResult: SearchResult, searchType: SearchType, searchCategory: HomeCategorySearch?) {
        functionsCalled.append(#function)
    }
    
    func displayAlert(title: String, message: String) {
        functionsCalled.append(#function)
    }
}
