//
//  SearchResultContract.swift
//  ProductSearch
//
//  Created by Luis Mejias on 17-03-22.
//  Copyright (c) 2022 Luis Mejías. All rights reserved.

import Combine
import UIKit

// MARK: - Factory

protocol SearchResultFactoryProtocol: AnyObject {
    static func initialize(homeSearchResult: SearchResult, searchType: SearchType, searchCategory: HomeCategorySearch?) -> SearchResultViewController
}

// MARK: - Interactor

protocol SearchResultInteractorProtocol: AnyObject {
    var repository: SearchResultRepositoryProtocol? { get set }
    var publisher: PassthroughSubject<SearchResultPublisherResult, Error>? { get set }

    func fetchNextOffSet(_ offSet: Int, searchText: String)
    func fetchNextOffSet(_ offSet: Int, category: String)
}

// MARK: - View

protocol SearchResultViewProtocol: AnyObject {
    var presenter: SearchResultPresenterProtocol? { get set }

    func displaySearchResult()
    func displayNextOffSetResult(_ nextOffSetResult: SearchResult, searchType: SearchType, searchCategory: HomeCategorySearch?)
    func endLoadingIndicator()
}

// MARK: - Router

protocol SearchResultRouterProtocol: AnyObject {
    var view: UIViewController? { get set }
    var delegate: SearchResultRouterDelegate? { get set }

    func presentFilterTypeActionSheet()
    func presentProductDetail(_ result: Result)
    func displayAlert(title: String, message: String)
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
    var searchResult: SearchResult { get set }
    var searchType: SearchType { get set }
    var searchCategory: HomeCategorySearch? { get set }

    func viewDidLoad()
    func presentFilterTypeActionSheet()
    func fetchNextOffSet()
    func presentProductDetail(_ result: Result)
}

enum SearchResultPublisherResult {
    case displayNextOffSet(searchResult: SearchResult)
    case displayNextOffSetFailed(Error)
}

enum FilterType {
    case lowestPrice
    case highestPrice
}

enum SearchType {
    case text
    case category
}
