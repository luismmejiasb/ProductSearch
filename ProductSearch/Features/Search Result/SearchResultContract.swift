//
//  SearchResultContract.swift
//  ProductSearch
//
//  Created by Luis Mejias on 17-03-22.
//  Copyright (c) 2022 Falabella FIF. All rights reserved.

import UIKit
import Combine

// MARK: - Factory
protocol SearchResultFactoryProtocol: AnyObject {
    static func initialize(homeSearchResult: SearchResult) -> SearchResultViewController
}

// MARK: - Interactor
protocol SearchResultInteractorProtocol: AnyObject {
    var repository: SearchResultRepositoryProtocol? { get set }
    var publisher: PassthroughSubject<SearchResultPublisherResult, Error>? { get set }
    
    func serachItem(offSet: Int, searchText: String)
}

// MARK: - View
protocol SearchResultViewProtocol: AnyObject {
    var presenter: SearchResultPresenterProtocol? { get set }
    
    func displayHomeSearchResult(_ homeSearchResult: SearchResult)
    func displayNextOffSetResult(_ nextOffSetResult: SearchResult)
    func displayNextOffSetResultError(_ error: Error)
}

// MARK: - Router
protocol SearchResultRouterProtocol: AnyObject {
    var view: UIViewController? { get set }
}

// MARK: - Presenter
protocol SearchResultPresenterProtocol: AnyObject {
    var interactor: SearchResultInteractorProtocol? { get set }
    var router: SearchResultRouterProtocol? { get set }
    var view: SearchResultViewProtocol? { get set }
    
    func viewDidLoad()
}

// MARK: - InteractorOutput
protocol SearchResultInteractorDelegate: AnyObject {
}

enum SearchResultPublisherResult {
    case displayNextOffSet(SearchResult)
    case displayNextOffSetFailed(Error)
}
