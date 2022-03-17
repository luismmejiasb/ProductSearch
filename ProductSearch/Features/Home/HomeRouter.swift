//
//  HomeRouter.swift
//  ProductSearch
//
//  Created by Luis Mejias on 15-03-22.
//  Copyright (c) 2022 Luis Mejías. All rights reserved.

import UIKit

// MARK: - HomeRouter
final class HomeRouter: HomeRouterProtocol {
    weak var view: UIViewController?
    
    func presentSearchResult(_ searchResult: SearchResult) {
        let searchResultViewController = SearchResultFactory.initialize(homeSearchResult: searchResult)

        if let navController = view?.navigationController {
            navController.pushViewController(searchResultViewController, animated: true)
        } else {
            view?.present(searchResultViewController, animated: true, completion: nil)
        }
    }
}
