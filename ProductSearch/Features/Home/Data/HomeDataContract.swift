//
//  HomeDataContract.swift
//  ProductSearch
//
//  Created by Luis Mejias on 15-03-22.
//  Copyright (c) 2022 Luis Mejías. All rights reserved.

// MARK: - Local Data Source

import Combine

protocol HomeLocalDataSourceProtocol {}

// MARK: - Cloud Data Source

protocol HomeCloudDataSourceProtocol {
    func searchItem(offSet: Int, searchText: String) -> Future<SearchResult, Error>
    func searchCategory(offSet: Int, category: String) -> Future<SearchResult, Error>
}

// MARK: - Repository

protocol HomeRepositoryProtocol {
    var localDataSource: HomeLocalDataSourceProtocol? { get set }
    var cloudDataSource: HomeCloudDataSourceProtocol? { get set }

    func searchItem(offSet: Int, searchText: String) -> Future<SearchResult, Error>
    func searchCategory(offSet: Int, category: String) -> Future<SearchResult, Error>
}

enum HomeCategorySearch: Int {
    case vehicule
    case realState
    case services

    var stringValue: String {
        switch self {
        case .vehicule:
            return "MLC1743"
        case .realState:
            return "MLC1459"
        case .services:
            return "MLC1540"
        }
    }

    var uiTitle: String {
        switch self {
        case .vehicule:
            return "Vehículos"
        case .realState:
            return "Inmuebles"
        case .services:
            return "Servicios"
        }
    }
}
