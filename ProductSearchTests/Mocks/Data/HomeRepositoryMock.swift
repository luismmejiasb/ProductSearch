//
//  HomeRepositoryMock.swift
//  Alamofire
//
//  Created by Luis Mejias on 22-03-22.
//

import Combine
import Foundation
@testable import ProductSearch

class HomeRepositoryMock: HomeRepositoryProtocol {
    private let status: TransactionStatus
    var functionsCalled = [String]()
    var localDataSource: HomeLocalDataSourceProtocol?
    var cloudDataSource: HomeCloudDataSourceProtocol?

    init(status: TransactionStatus,
         localDataSource: HomeLocalDataSourceProtocol?,
         cloudDataSource: HomeCloudDataSourceProtocol?)
    {
        self.status = status
        self.cloudDataSource = cloudDataSource
        self.localDataSource = localDataSource
    }

    func searchItem(offSet: Int, searchText: String) -> Future<SearchResult, Error> {
        functionsCalled.append(#function)
        return (cloudDataSource?.searchItem(offSet: offSet, searchText: searchText))!
    }

    func searchCategory(offSet: Int, category: String) -> Future<SearchResult, Error> {
        functionsCalled.append(#function)
        return (cloudDataSource?.searchCategory(offSet: offSet, category: category))!
    }
}
