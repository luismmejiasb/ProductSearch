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

    var url: URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.mercadolibre.com"
        urlComponents.path = path
        
        guard let uwrappedUrl = URL(string: "https://api.mercadolibre.com/sites/MLC" + path) else {
            fatalError("The provided URL must be valid")
        }
        
        return uwrappedUrl
    }
}

extension APIURL {
    fileprivate var path: String {
        switch self {
        case .getCategories:
            return "/users"
        case .searchItem(let offSet, let searchText):
            return "/search?limit=30&offset=\(offSet)&q=\(searchText)"
        }
    }
}

//API.getUsers(pageIndex: 2).url!
//API.postRegister.url!
