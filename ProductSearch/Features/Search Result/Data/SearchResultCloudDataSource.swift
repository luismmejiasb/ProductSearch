//
//  SearchResultCloudDataSource.swift
//  ProductSearch
//
//  Created by Luis Mejias on 17-03-22.
//  Copyright (c) 2022 Luis Mejías. All rights reserved.
//
import Foundation
import Combine
import Alamofire

// MARK: - SearchResultCloudDataSource
final class SearchResultCloudDataSource: SearchResultCloudDataSourceProtocol {
    func searchItem(offSet: Int, searchText: String) -> Future<SearchResult, Error> {
        return Future { promise in
            AF.request(APIURL.searchItem(offSet: offSet, searchText: searchText).url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
                switch response.result {
                case .success(let response):
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                        let searchResult = try JSONDecoder().decode(SearchResult.self, from: jsonData)
                        return promise(.success(searchResult))
                    } catch {
                        return promise(.failure(CloudDataSourceDefaultError.responseCannotBeParsed))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
    
    func searchCategory(offSet: Int, category: String) -> Future<SearchResult, Error> {
        return Future { promise in
            AF.request(APIURL.searchByCategory(offSet: offSet, category: category).url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
                switch response.result {
                case .success(let response):
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                        let searchResult = try JSONDecoder().decode(SearchResult.self, from: jsonData)
                        return promise(.success(searchResult))
                    } catch {
                        return promise(.failure(CloudDataSourceDefaultError.responseCannotBeParsed))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
}
