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
    @IBOutlet weak var resultCountLabel: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    var presenter: SearchResultPresenterProtocol?
    private var searchText = ""
    var searchResult: SearchResult? {
        didSet {
            searchText = searchResult?.query ?? "Tu producto"
        }
    }

    // MARK: Object lifecycle
    init() {
       super.init(nibName: String(describing: SearchResultViewController.self), bundle: Bundle(for: SearchResultViewController.classForCoder()))
    }

    required init?(coder aDecoder: NSCoder) {
       fatalError("Missing presenter")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setUpUI()
    }
    @IBAction func filterSearchResult(_ sender: Any) {
        presenter?.presentFilterTypeActionSheet()
    }
}

// MARK: Private functions
private extension SearchResultViewController {
    func setUpUI() {
        title = "Resultados para \(searchText)"
        if let paging = searchResult?.paging,
           let totalCount = paging.total {
            resultCountLabel.text = "\(totalCount) \((totalCount != 1) ? "resultados" : "resultado")"
        } else {
            resultCountLabel.text = "Filtra los resultados de tu búsqueda"
        }
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
        searchResultTableView.reloadData()
        UILoadingIndicator.endLoadingIndicator(view)
    }

    func displayNextOffSetResultError(_ error: Error) {
        
    }
}
