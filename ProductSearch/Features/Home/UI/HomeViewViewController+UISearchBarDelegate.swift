//
//  HomeView+UISearchBarDelegate.swift
//  ProductSearch
//
//  Created by Luis Mejias on 17-03-22.
//

import Foundation
import UIKit

extension HomeViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else {
            return
        }
        searchBar.resignFirstResponder()
        presenter?.serachItem(offSet: 0, searchText: searchBarText)
    }
}


