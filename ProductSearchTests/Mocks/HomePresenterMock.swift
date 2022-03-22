//
//  HomePresenterMock.swift
//  Alamofire
//
//  Created by Luis Mejias on 22-03-22.
//

import Foundation
@testable import ProductSearch

class HomePresenterMock: HomePresenterProtocol {
    var interactor: HomeInteractorProtocol?
    var router: HomeRouterProtocol?
    var view: HomeViewControllerProtocol?
    var functionsCalled = [String]()
    
    func viewDidLoad() {
        functionsCalled.append(#function)
    }
    
    func searchItem(searchText: String) {
        functionsCalled.append(#function)
    }
    
    func searchByCategory(_ category: HomeCategorySearch) {
        functionsCalled.append(#function)
    }
    
    func presentSearchResult(_ searchResult: SearchResult, searchType: SearchType, searchCategory: HomeCategorySearch?) {
        functionsCalled.append(#function)
    }
    
}
