//
//  HomeViewController.swift
//  ProductSearch
//
//  Created by Luis Mejias on 15-03-22.
//  Copyright (c) 2022 Luis Mejías. All rights reserved.

import UIKit

// MARK: - HomeViewController
final class HomeViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
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
        searchBar.searchTextField.text = "iPhone"
    }
}

// MARK: Private UI functions
private extension HomeViewController {
    func setUpUI() {
        searchBar.delegate = self
        searchBar.setValue("Buscar", forKey: "cancelButtonText")
        searchBar.placeholder = "Nombre de producto"
    }
}

// MARK: HomeViewProtocol
extension HomeViewController: HomeViewProtocol {
    func displaySearchResult(_ searchResult: SearchResult) {
        presenter?.presentSearchResult(searchResult)
    }
    
    func displaySearchResultError(_ error: Error) {
        print(error.localizedDescription)
    }
    
}
