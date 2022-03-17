//
//  ProductDetailRepository.swift
//  ProductSearch
//
//  Created by Luis Mejias on 17-03-22.
//  Copyright (c) 2022 Falabella FIF. All rights reserved.

// MARK: - ProductDetailRepository
final class ProductDetailRepository: ProductDetailRepositoryProtocol {
	var localDataSource: ProductDetailLocalDataSourceProtocol?
    var cloudDataSource: ProductDetailCloudDataSourceProtocol?

    // MARK: - Inits
    init(localDataSource: ProductDetailLocalDataSourceProtocol?, cloudDataSource: ProductDetailCloudDataSourceProtocol?) {
        self.localDataSource = localDataSource
        self.cloudDataSource = cloudDataSource
    }
}
