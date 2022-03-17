//
//  HomeCloudDataSource.swift
//  ProductSearch
//
//  Created by Luis Mejias on 15-03-22.
//  Copyright (c) 2022 Luis Mejías. All rights reserved.
//

// MARK: - HomeCloudDataSource
import Combine
import Foundation

final class HomeCloudDataSource: HomeCloudDataSourceProtocol {
    func searchItem(offSet: Int, searchText: String) -> Future<HomeSearchResultCodable, Error> {
        return Future { promise in
            let task = URLSession.shared.dataTask(with: APIURL.searchItem(offSet: 0, searchText: searchText).url) { data, response, error in
                guard error == nil else {
                    return promise(.failure(HomeCloudDataSourceDefaultError.responseCannotBeParsed))
                }
                
                guard let data = data,
                      let searchResult = try? JSONDecoder().decode(HomeSearchResultCodable.self, from: data) else {
                    return promise(.failure(HomeCloudDataSourceDefaultError.responseCannotBeParsed))
                }

                return promise(.success(searchResult))
            }
            task.resume()
        }
    }
}
