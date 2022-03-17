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
import Alamofire

final class HomeCloudDataSource: HomeCloudDataSourceProtocol {
    func searchItem(offSet: Int = 0, searchText: String) -> Future<SearchResult, Error> {
        return Future { promise in
            AF.request(APIURL.searchItem(offSet: 0, searchText: searchText).url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
                
                switch response.result {
                case .success(let response):
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                        let searchResult = try JSONDecoder().decode(SearchResult.self, from: jsonData)
                        return promise(.success(searchResult))
                    } catch {
                        return promise(.failure(HomeCloudDataSourceDefaultError.responseCannotBeParsed))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
}
