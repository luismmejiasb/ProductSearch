//
//  HomeViewController.swift
//  ProductSearch
//
//  Created by Luis Mejias on 15-03-22.
//  Copyright (c) 2022 Luis Mejías. All rights reserved.

import UIKit

// MARK: - HomeViewController
final class HomeViewController: UIViewController {
    var searchBar: UISearchBar! {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width), height: 70))
        searchBar.backgroundColor = UIColors.normalTintColor
        searchBar.delegate = self
        searchBar.setValue("Cancelar", forKey: "cancelButtonText")
        searchBar.placeholder = "Nombre de producto"
        return searchBar
    }
	var presenter: HomePresenterProtocol?

    // MARK: Object lifecycle
    init() {
       super.init(nibName: String(describing: HomeViewController.self), bundle: Bundle(for: HomeViewController.classForCoder()))
    }

    required init?(coder aDecoder: NSCoder) {
       fatalError("Missing presenter")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        presenter?.viewDidLoad()
    }
}

// MARK: Private UI functions
private extension HomeViewController {
    func setUpUI() {
        self.navigationItem.titleView = searchBar
    }
}

// MARK: HomeViewProtocol
extension HomeViewController: HomeViewProtocol {
    func displaySearchResult(_ searchResult: SearchResult) {
        UILoadingIndicator.endLoadingIndicator(view)
        presenter?.presentSearchResult(searchResult)
    }
    
    func displaySearchResultError(_ error: Error) {
        print(error.localizedDescription)
    }
    
}
