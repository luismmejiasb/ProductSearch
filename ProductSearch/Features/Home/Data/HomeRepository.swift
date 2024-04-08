//
//  HomeRepository.swift
//  ProductSearch
//
//  Created by Luis Mejias on 15-03-22.
//  Copyright (c) 2022 Luis Mejías. All rights reserved.

// MARK: - HomeRepository

import Combine

final class HomeRepository: HomeRepositoryProtocol {
    var localDataSource: HomeLocalDataSourceProtocol?
    var cloudDataSource: HomeCloudDataSourceProtocol?

    // MARK: - Inits

    init(localDataSource: HomeLocalDataSourceProtocol?, cloudDataSource: HomeCloudDataSourceProtocol?) {
        self.localDataSource = localDataSource
        self.cloudDataSource = cloudDataSource
    }

    func searchItem(offSet: Int, searchText: String) -> Future<SearchResult, Error> {
        guard let cloudDataSource = cloudDataSource else {
            return Future { promise in
                promise(.failure(CloudDataSourceDefaultError.unwrappableValue))
            }
        }

        return cloudDataSource.searchItem(offSet: offSet, searchText: searchText)
    }

    func searchCategory(offSet: Int, category: String) -> Future<SearchResult, Error> {
        guard let cloudDataSource = cloudDataSource else {
            return Future { promise in
                promise(.failure(CloudDataSourceDefaultError.unwrappableValue))
            }
        }

        return cloudDataSource.searchCategory(offSet: offSet, category: category)
    }
}
