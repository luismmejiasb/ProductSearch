//
//  HomeInteractor.swift
//  ProductSearch
//
//  Created by Luis Mejias on 15-03-22.
//  Copyright (c) 2022 Luis Mejías. All rights reserved.

// MARK: - HomeInteractor

import Combine

final class HomeInteractor: HomeInteractorProtocol {
	var repository: HomeRepositoryProtocol?
    var publisher: PassthroughSubject<HomePublisherResult, Error>?

    // MARK: - Inits
    init(repository: HomeRepositoryProtocol?) {
        self.repository = repository
    }
    
    func serachItem(searchText: String) {
        repository?.serachItem(searchText: searchText)
    }
}
