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

    func searchItem(searchText _: String) {
        functionsCalled.append(#function)
    }

    func searchByCategory(_: HomeCategorySearch) {
        functionsCalled.append(#function)
    }

    func presentSearchResult(_: SearchResult, searchType _: SearchType, searchCategory _: HomeCategorySearch?) {
        functionsCalled.append(#function)
    }
}
