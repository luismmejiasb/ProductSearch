//
//  SearchResultRepository.swift
//  ProductSearch
//
//  Created by Luis Mejias on 17-03-22.
//  Copyright (c) 2022 Luis Mejías. All rights reserved.
import Combine

// MARK: - SearchResultRepository
final class SearchResultRepository: SearchResultRepositoryProtocol {
	var localDataSource: SearchResultLocalDataSourceProtocol?
    var cloudDataSource: SearchResultCloudDataSourceProtocol?

    // MARK: - Inits
    init(localDataSource: SearchResultLocalDataSourceProtocol?, cloudDataSource: SearchResultCloudDataSourceProtocol?) {
        self.localDataSource = localDataSource
        self.cloudDataSource = cloudDataSource
    }
    
    func searchItem(offSet: Int, searchText: String) -> Future<SearchResult, Error> {
        guard let cloudDataSource = self.cloudDataSource else {
            return Future { promise in
                promise(.failure(CloudDataSourceDefaultError.unwrappableValue))
            }
        }

        return cloudDataSource.searchItem(offSet: offSet, searchText: searchText)
    }
    
    func searchCategory(offSet: Int, category: String) -> Future<SearchResult, Error> {
        guard let cloudDataSource = self.cloudDataSource else {
            return Future { promise in
                promise(.failure(CloudDataSourceDefaultError.unwrappableValue))
            }
        }

        return cloudDataSource.searchCategory(offSet: offSet, category: category)
    }

}
