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
}

// MARK: - View
protocol HomeViewProtocol: AnyObject {
    var presenter: HomePresenterProtocol? { get set }
    
    func displaySearchResults(_ searchResults: [String:Any])
    func displaySearchResultsError(_ error: Error)
}

// MARK: - Router
protocol HomeRouterProtocol: AnyObject {
    var view: UIViewController? { get set }
}

// MARK: - Presenter
protocol HomePresenterProtocol: AnyObject {
    var interactor: HomeInteractorProtocol? { get set }
    var router: HomeRouterProtocol? { get set }
    var view: HomeViewProtocol? { get set }

    func viewDidLoad()
    func testSearch()
}

enum HomePublisherResult {
    case itemsSearchedWithSuccess([String:Any])
    case itemsSearchedWithFailure(Error)
}
