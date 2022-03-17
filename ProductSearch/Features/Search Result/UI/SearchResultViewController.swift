//
//  SearchResultViewController.swift
//  ProductSearch
//
//  Created by Luis Mejias on 17-03-22.
//  Copyright (c) 2022 Falabella FIF. All rights reserved.

import UIKit

// MARK: - SearchResultViewController
final class SearchResultViewController: UIViewController {
    @IBOutlet weak var searchResultTableView: UITableView! {
        didSet {
            searchResultTableView.register(SearchResultUITableViewCell.nib, forCellReuseIdentifier: SearchResultUITableViewCell.reusableIdentifier)
            searchResultTableView.delegate = self
            searchResultTableView.dataSource = self
        }
    }
    var presenter: SearchResultPresenterProtocol?
    var searchText = ""
    var searchResult: SearchResult?

    // MARK: Object lifecycle
    init() {
       super.init(nibName: String(describing: SearchResultViewController.self), bundle: Bundle(for: SearchResultViewController.classForCoder()))
    }

    required init?(coder aDecoder: NSCoder) {
       fatalError("Missing presenter")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
}

// MARK: View Life Cycle
private extension SearchResultViewController {
    func setUpUI() {
        title = "Resultados para \(searchText)"
    }
}

// MARK: SearchResultViewProtocol
extension SearchResultViewController: SearchResultViewProtocol {
    func displayHomeSearchResult(_ homeSearchResult: SearchResult) {
        searchResult = homeSearchResult
        searchResultTableView.reloadData()
    }

    func displayNextOffSetResult(_ nextOffSetResult: SearchResult) {
        guard let searchResults = self.searchResult?.results,
              let nextOffSetResults = nextOffSetResult.results else {
            return
        }
        self.searchResult?.results = searchResults + nextOffSetResults
    }

    func displayNextOffSetResultError(_ error: Error) {
        
    }
}