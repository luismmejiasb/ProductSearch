//
//  HomeContract.swift
//  ProductSearch
//
//  Created by Luis Mejias on 15-03-22.
//  Copyright (c) 2022 Luis Mejías. All rights reserved.

import UIKit
import Combine

// MARK: - Factory
protocol HomeFactoryProtocol: AnyObject {
    static func initialize() -> HomeViewController
}

// MARK: - Interactor
protocol HomeInteractorProtocol: AnyObject {
    var repository: HomeRepositoryProtocol? { get set }
    var publisher: PassthroughSubject<HomePublisherResult, Error>? { get set }
    
    func serachItem(searchText: String)
    func searchByCategory(_ category: HomeCategorySearch)
}

// MARK: - View
protocol HomeViewProtocol: AnyObject {
    var presenter: HomePresenterProtocol? { get set }
    
    func displaySearchResult(_ searchResults: SearchResult, searchType: SearchType, searchCategory: HomeCategorySearch?)
    func endLoadingIndicator()
}

// MARK: - Router
protocol HomeRouterProtocol: AnyObject {
    var view: UIViewController? { get set }

    func presentSearchResult(_ searchResult: SearchResult, searchType: SearchType, searchCategory: HomeCategorySearch?)
    func displayAlert(title: String, message: String)
}

// MARK: - Presenter
protocol HomePresenterProtocol: AnyObject {
    var interactor: HomeInteractorProtocol? { get set }
    var router: HomeRouterProtocol? { get set }
    var view: HomeViewProtocol? { get set }

    func viewDidLoad()
    func searchItem(searchText: String)
    func searchByCategory(_ category: HomeCategorySearch)
    func presentSearchResult(_ searchResult: SearchResult, searchType: SearchType, searchCategory: HomeCategorySearch?)
}

enum HomePublisherResult {
    case itemsSearchedWithSuccess(searchResult: SearchResult)
    case itemsSearchedWithFailure(Error)
    case categorySearchedWithSuccess(searchResult: SearchResult, searchedCategory: HomeCategorySearch)
    case categorySearchedWithFailure(Error)
}
