//
//  SearchResultDataContract.swift
//  ProductSearch
//
//  Created by Luis Mejias on 17-03-22.
//  Copyright (c) 2022 Luis Mejías. All rights reserved.
import Combine

// MARK: - Local Data Source
protocol SearchResultLocalDataSourceProtocol {
}

// MARK: - Cloud Data Source
protocol SearchResultCloudDataSourceProtocol {
    func searchItem(offSet: Int, searchText: String) -> Future<SearchResult, Error>
    
    func searchCategory(offSet: Int, category: String) -> Future<SearchResult, Error>
}

// MARK: - Repository
protocol SearchResultRepositoryProtocol {
    var localDataSource: SearchResultLocalDataSourceProtocol? { get set }
    var cloudDataSource: SearchResultCloudDataSourceProtocol? { get set }

    func searchItem(offSet: Int, searchText: String) -> Future<SearchResult, Error>
    func searchCategory(offSet: Int, category: String) -> Future<SearchResult, Error>
}
