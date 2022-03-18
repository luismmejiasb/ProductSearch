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
    
    func fetchNextOffSet(_ offSet: Int, searchText: String)
}

// MARK: - View
protocol SearchResultViewProtocol: AnyObject {
    var presenter: SearchResultPresenterProtocol? { get set }
    
    func displaySearchResult()
    func displayNextOffSetResult(_ nextOffSetResult: SearchResult)
    func displayNextOffSetResultError(_ error: Error)
}

// MARK: - Router
protocol SearchResultRouterProtocol: AnyObject {
    var view: UIViewController? { get set }
    var delegate: SearchResultRouterDelegate? { get set}

    func presentFilterTypeActionSheet()
    func presentProductDetail(_ result: Result)
}

// MARK: - Router Delegate

protocol SearchResultRouterDelegate: AnyObject {
    func didSelectFilter(_ filter: FilterType)
}

// MARK: - Presenter
protocol SearchResultPresenterProtocol: AnyObject {
    var interactor: SearchResultInteractorProtocol? { get set }
    var router: SearchResultRouterProtocol? { get set }
    var view: SearchResultViewProtocol? { get set }
    var searchResult: SearchResult { get set}

    func viewDidLoad()
    func presentFilterTypeActionSheet()
    func fetchNextOffSet()
    func presentProductDetail(_ result: Result)
}

// MARK: - InteractorOutput
protocol SearchResultInteractorDelegate: AnyObject {
}

enum SearchResultPublisherResult {
    case displayNextOffSet(SearchResult)
    case displayNextOffSetFailed(Error)
}

enum FilterType {
    case lowestPrice
    case highestPrice
}
