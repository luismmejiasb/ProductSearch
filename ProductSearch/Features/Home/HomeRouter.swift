//
//  HomeRouter.swift
//  ProductSearch
//
//  Created by Luis Mejias on 15-03-22.
//  Copyright (c) 2022 Luis Mejías. All rights reserved.

import UIKit

// MARK: - HomeRouter

final class HomeRouter: HomeRouterProtocol {
    weak var view: HomeViewControllerProtocol?

    func presentSearchResult(_ searchResult: SearchResult, searchType: SearchType, searchCategory: HomeCategorySearch?) {
        let searchResultViewController = SearchResultFactory.initialize(homeSearchResult: searchResult, searchType: searchType, searchCategory: searchCategory)

        if let navController = view?.navigationController {
            navController.pushViewController(searchResultViewController, animated: true)
        } else {
            view?.present(searchResultViewController, animated: true, completion: nil)
        }
    }

    func presentSearchResult(_ searchResult: SearchResult) {
        let searchResultViewController = SearchResultFactory.initialize(homeSearchResult: searchResult, searchType: .text)

        if let navController = view?.navigationController {
            navController.pushViewController(searchResultViewController, animated: true)
        } else {
            view?.present(searchResultViewController, animated: true, completion: nil)
        }
    }

    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
        view?.present(alert, animated: true, completion: nil)
    }
}
