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
    private lazy var filterButton: UIBarButtonItem = {
        let filterButton = UIBarButtonItem(image: #imageLiteral(resourceName: "filterIcon"), style: .plain, target: self, action: #selector(filterSearchResult))
        filterButton.isEnabled = (presenter?.searchResult.paging?.total ?? 0) != 0
        return filterButton
    }()
    var presenter: SearchResultPresenterProtocol?
    private var searchText = ""

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
        title = "Resultados para \(presenter?.searchResult.query ?? "")"

        if let paging = presenter?.searchResult.paging,
           let totalCount = paging.total {
            resultCountLabel.text = "\(totalCount) \((totalCount != 1) ? "resultados" : "resultado")"
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            resultCountLabel.text = "Filtra los resultados de tu búsqueda"
        }

        self.navigationItem.setRightBarButtonItems([filterButton], animated: false)
    }
}

// MARK: SearchResultViewProtocol
extension SearchResultViewController: SearchResultViewProtocol {
    func displaySearchResult() {
        searchResultTableView.reloadData()
    }

    func displayNextOffSetResult(_ nextOffSetResult: SearchResult) {
        guard let searchResults = presenter?.searchResult.results,
              let nextOffSetResults = nextOffSetResult.results else {
            return
        }
        presenter?.searchResult.results = searchResults + nextOffSetResults
        searchResultTableView.reloadData()
        UILoadingIndicator.endLoadingIndicator(view)
    }
    
    func endLoadingIndicator() {
        UILoadingIndicator.endLoadingIndicator(view)
    }
}
