//
//  ProductDetailInteractor.swift
//  ProductSearch
//
//  Created by Luis Mejias on 17-03-22.
//  Copyright (c) 2022 Luis Mejías. All rights reserved.

// MARK: - ProductDetailInteractor
final class ProductDetailInteractor: ProductDetailInteractorProtocol {
	var repository: ProductDetailRepositoryProtocol?

    // MARK: - Inits
    init(repository: ProductDetailRepositoryProtocol?) {
        self.repository = repository
    }
}
