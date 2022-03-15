//
//  HomeViewController.swift
//  ProductSearch
//
//  Created by Luis Mejias on 15-03-22.
//  Copyright (c) 2022 Luis Mejías. All rights reserved.

import UIKit

// MARK: - HomeViewController
final class HomeViewController: UIViewController {
	var presenter: HomePresenterProtocol?

    // MARK: Object lifecycle
    init() {
       super.init(nibName: String(describing: HomeViewController.self), bundle: Bundle(for: HomeViewController.classForCoder()))
    }

    required init?(coder aDecoder: NSCoder) {
       fatalError("Missing presenter")
    }
}

// MARK: View Life Cycle
extension HomeViewController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        presenter?.testSearch()
    }
}

// MARK: HomeViewProtocol
extension HomeViewController: HomeViewProtocol {
    func displaySearchResults(_ searchResults: [String : Any]) {
        print(searchResults)
    }
    
    func displaySearchResultsError(_ error: Error) {
        print(error.localizedDescription)
    }
    
}
