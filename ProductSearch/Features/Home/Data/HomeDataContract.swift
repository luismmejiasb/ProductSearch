//
//  HomeDataContract.swift
//  ProductSearch
//
//  Created by Luis Mejias on 15-03-22.
//  Copyright (c) 2022 Luis Mejías. All rights reserved.

// MARK: - Local Data Source
import Combine

protocol HomeLocalDataSourceProtocol {
}

// MARK: - Cloud Data Source
protocol HomeCloudDataSourceProtocol {
    func searchItem(offSet: Int, searchText: String) -> Future<SearchResult, Error>
}

// MARK: - Repository
protocol HomeRepositoryProtocol {
    var localDataSource: HomeLocalDataSourceProtocol? { get set }
    var cloudDataSource: HomeCloudDataSourceProtocol? { get set }
    
    func searchItem(offSet: Int, searchText: String) -> Future<SearchResult, Error>
}
