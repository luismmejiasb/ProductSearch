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
    func searchItem(searchText: String) -> Future<HomeResultCodable, Error> {
        return Future { promise in
            let _ = URLSession.shared.dataTaskPublisher(for: APIURL.searchItem(searchText: searchText).url)
                .tryMap { output in
                    if let response = output.response as? HTTPURLResponse, response.statusCode != 200 {
                        throw HomeCloudDataSourceDefaultError.httpError(code: response.statusCode, message: "Test")
                    }
                    return output.data
                }
                .decode(type: HomeResultCodable.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Finished")
                        break
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    }
                }, receiveValue: { resultSearchCodable in
                    print(resultSearchCodable)
                })

//            AF.request(requestUrlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
//                switch response.result {
//                case .success(let response):
//                    do {
//                        let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
//                        let searchResult = try JSONDecoder().decode(SearchResult.self, from: jsonData)
//                        return promise(.success(searchResult.results))
//                    } catch {
//                        return promise(.failure(CloudSourceErrors.responseCannotBeParsed))
//                    }
//
//                case .failure(let error):
//                    promise(.failure(error))
//                }
//            }
        }
    }
}
