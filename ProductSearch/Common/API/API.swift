//
//  API.swift
//  ProductSearch
//
//  Created by Luis Mejias on 15-03-22.
//

import Foundation

enum APIURL {
    case getCategories
    case searchItem(searchText: String)

    var url: URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.mercadolibre.com"
        urlComponents.path = path
        
        guard let uwrappedUrl = urlComponents.url else {
            fatalError("The provided URL must be valid")
        }
        
        return uwrappedUrl
    }
}

extension APIURL {
    fileprivate var path: String {
        switch self {
        case .getCategories:
            return "/sites/users"
        case .searchItem(let searchText):
            return "/sites/MLA/search?q=\(searchText)"
        }
    }
}

//API.getUsers(pageIndex: 2).url!
//API.postRegister.url!
