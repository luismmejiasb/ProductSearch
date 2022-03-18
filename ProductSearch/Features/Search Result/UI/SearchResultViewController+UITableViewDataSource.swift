//
//  SearchResultViewController+UITableViewDataSource.swift
//  ProductSearch
//
//  Created by Luis Mejias on 17-03-22.
//

import Foundation
import UIKit

extension SearchResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.searchResult.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: SearchResultUITableViewCell = tableView.dequeueReusableCell(withIdentifier: SearchResultUITableViewCell.reusableIdentifier,
                                                                                    for: indexPath) as? SearchResultUITableViewCell,
              let result: Result = presenter?.searchResult.results?[indexPath.row] else {
            return UITableViewCell()
        }

        cell.configureCell(with: result)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == presenter?.searchResult.results?.count {
            UILoadingIndicator.startLoadingIndicatorIn(view ?? UIView(), position: .bottom)
            presenter?.fetchNextOffSet()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
    }
}
