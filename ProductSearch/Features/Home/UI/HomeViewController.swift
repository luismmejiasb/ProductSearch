//
//  HomeViewController.swift
//  ProductSearch
//
//  Created by Luis Mejias on 15-03-22.
//  Copyright (c) 2022 Luis Mejías. All rights reserved.

import UIKit

// MARK: - HomeViewController

final class HomeViewController: HomeViewControllerProtocol {
    var searchBar: UISearchBar! {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 70))
        searchBar.backgroundColor = UIColor.themeRegularColor
        searchBar.delegate = self
        searchBar.setValue("Cancelar", forKey: "cancelButtonText")
        searchBar.placeholder = "Busca en Mercado Libre"
        return searchBar
    }

    var presenter: HomePresenterProtocol?

    // MARK: Object lifecycle

    init() {
        super.init(nibName: String(describing: HomeViewController.self), bundle: Bundle(for: HomeViewController.classForCoder()))
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("Missing presenter")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        presenter?.viewDidLoad()
    }

    @IBAction func searchByCategory(_ sender: UIButton) {
        guard let category = HomeCategorySearch(rawValue: sender.tag) else {
            return
        }
        UILoadingIndicator.startLoadingIndicatorIn(view, position: .top)
        presenter?.searchByCategory(category)
    }
}

// MARK: Private UI functions

private extension HomeViewController {
    func setUpUI() {
        navigationItem.titleView = searchBar
    }
}

// MARK: HomeViewProtocol

extension HomeViewController {
    func displaySearchResult(_ searchResult: SearchResult, searchType: SearchType, searchCategory: HomeCategorySearch?) {
        UILoadingIndicator.endLoadingIndicator(view)
        presenter?.presentSearchResult(searchResult, searchType: searchType, searchCategory: searchCategory)
    }

    func endLoadingIndicator() {
        UILoadingIndicator.endLoadingIndicator(view)
    }
}
