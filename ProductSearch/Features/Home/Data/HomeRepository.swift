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
    
    func serachItem(searchText: String) -> Future<HomeResultCodable, Error> {
        guard let cloudDataSource = self.cloudDataSource else {
            return Future { promise in
                promise(.failure(HomeCloudDataSourceDefaultError.unwrappableValue))
            }
        }

        return cloudDataSource.searchItem(searchText: searchText)
    }
}
