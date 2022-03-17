//
//  SearchResultCloudDataSource.swift
//  ProductSearch
//
//  Created by Luis Mejias on 17-03-22.
//  Copyright (c) 2022 Falabella FIF. All rights reserved.
//
import Foundation
import Combine

// MARK: - SearchResultCloudDataSource
final class SearchResultCloudDataSource: SearchResultCloudDataSourceProtocol {
    func searchItem(offSet: Int, searchText: String) -> Future<SearchResult, Error> {
        return Future { promise in
            let task = URLSession.shared.dataTask(with: APIURL.searchItem(offSet: offSet, searchText: searchText).url) { data, response, error in
                guard error == nil else {
                    return promise(.failure(HomeCloudDataSourceDefaultError.responseCannotBeParsed))
                }
                
                guard let data = data,
                      let searchResult = try? JSONDecoder().decode(SearchResult.self, from: data) else {
                    return promise(.failure(HomeCloudDataSourceDefaultError.responseCannotBeParsed))
                }

                return promise(.success(searchResult))
            }
            task.resume()
        }
    }
}
