//
//  SearchResultCloudDataSource.swift
//  ProductSearch
//
//  Created by Luis Mejias on 17-03-22.
//  Copyright (c) 2022 Luis Mejías. All rights reserved.
//
import Alamofire
import Combine
import Foundation

// MARK: - SearchResultCloudDataSource

final class SearchResultCloudDataSource: SearchResultCloudDataSourceProtocol {
    func searchItem(offSet: Int, searchText: String) -> Future<SearchResult, Error> {
        return Future { promise in
            AF.request(APIURL.searchItem(offSet: offSet, searchText: searchText).url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
                switch response.result {
                case let .success(response):
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                        let searchResult = try JSONDecoder().decode(SearchResult.self, from: jsonData)
                        return promise(.success(searchResult))
                    } catch {
                        return promise(.failure(CloudDataSourceDefaultError.responseCannotBeParsed))
                    }
                case let .failure(error):
                    promise(.failure(error))
                }
            }
        }
    }

    func searchCategory(offSet: Int, category: String) -> Future<SearchResult, Error> {
        return Future { promise in
            AF.request(APIURL.searchByCategory(offSet: offSet, category: category).url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
                switch response.result {
                case let .success(response):
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                        let searchResult = try JSONDecoder().decode(SearchResult.self, from: jsonData)
                        return promise(.success(searchResult))
                    } catch {
                        return promise(.failure(CloudDataSourceDefaultError.responseCannotBeParsed))
                    }
                case let .failure(error):
                    promise(.failure(error))
                }
            }
        }
    }
}
