//
//  ProductDetailDataContract.swift
//  ProductSearch
//
//  Created by Luis Mejias on 17-03-22.
//  Copyright (c) 2022 Luis Mejías. All rights reserved.

// MARK: - Local Data Source
protocol ProductDetailLocalDataSourceProtocol {
}

// MARK: - Cloud Data Source
protocol ProductDetailCloudDataSourceProtocol {
}

// MARK: - Repository
protocol ProductDetailRepositoryProtocol {
    var localDataSource: ProductDetailLocalDataSourceProtocol? { get set }
    var cloudDataSource: ProductDetailCloudDataSourceProtocol? { get set }
}
