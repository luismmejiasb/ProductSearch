//
//  HomeCloudDataSourceMock.swift
//  Alamofire
//
//  Created by Luis Mejias on 22-03-22.
//

import Foundation
import Combine
@testable import ProductSearch

class HomeCloudDataSourceMock: HomeCloudDataSourceProtocol {
    var status: TransactionStatus = .success
    
    init(status: TransactionStatus) {
        self.status = status
    }

    func searchItem(offSet: Int, searchText: String) -> Future<SearchResult, Error> {
        return Future { promise in
            if self.status == .success {
                return promise(.success(HomeMLCDataMock.homeSearchItem.searchDefaultResult!))
            } else {
                return promise(.failure(CloudDataSourceDefaultError.httpError(code: 1002, message: "Test Error")))
            }
        }
    }
    
    func searchCategory(offSet: Int, category: String) -> Future<SearchResult, Error> {
        return Future { promise in
            if self.status == .success {
                return promise(.success(HomeMLCDataMock.homeSearchItem.searchDefaultResult!))
            } else {
                return promise(.failure(CloudDataSourceDefaultError.httpError(code: 1002, message: "Test Error")))
            }
        }
    }
}
