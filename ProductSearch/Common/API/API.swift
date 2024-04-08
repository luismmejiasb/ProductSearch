//
//  API.swift
//  ProductSearch
//
//  Created by Luis Mejias on 15-03-22.
//

import Foundation

enum APIURL {
    case getCategories
    case searchItem(offSet: Int, searchText: String)
    case searchByCategory(offSet: Int, category: String)

    var url: URL {
        guard let uwrappedUrl = URL(string: "https://api.mercadolibre.com/sites/MLC" + path) else {
            return URL(string: "https://api.mercadolibre.com/sites/MLC")!
        }

        return uwrappedUrl
    }
}

private extension APIURL {
    var path: String {
        switch self {
        case .getCategories:
            return "/users"
        case let .searchItem(offSet, searchText):
            return "/search?limit=50&offset=\(offSet)&q=\(searchText.replacingOccurrences(of: " ", with: "%20"))"
        case let .searchByCategory(offSet, category):
            return "/search?limit=50&category=\(category)&offset=\(offSet)"
        }
    }
}
