//
//  HomeViewMock.swift
//  Alamofire
//
//  Created by Luis Mejias on 22-03-22.
//

import Foundation
@testable import ProductSearch

class HomeViewMock: HomeViewControllerProtocol {
    var presenter: HomePresenterProtocol?
    var functionsCalled = [String]()

    func displaySearchResult(_ searchResults: SearchResult, searchType: SearchType, searchCategory: HomeCategorySearch?) {
        functionsCalled.append(#function)
    }
    
    func endLoadingIndicator() {
        functionsCalled.append(#function)
    }
}
