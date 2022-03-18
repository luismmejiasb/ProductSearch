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
            return "/search?limit=50&offset=\(offSet)&q=\(searchText.replacingOccurrences(of: " ", with: "%20"))"
        }
    }
}

//API.getUsers(pageIndex: 2).url!
//API.postRegister.url!
