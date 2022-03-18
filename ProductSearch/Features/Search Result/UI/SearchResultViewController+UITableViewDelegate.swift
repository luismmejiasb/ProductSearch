//
//  SearchResultViewController+UITableViewDelegate.swift
//  ProductSearch
//
//  Created by Luis Mejias on 17-03-22.
//

import Foundation
import UIKit

extension SearchResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let results = presenter?.searchResult.results,
              results.indices.contains(indexPath.row) else { return}
        let product = results[indexPath.row]

        presenter?.presentProductDetail(product)
    }
}
