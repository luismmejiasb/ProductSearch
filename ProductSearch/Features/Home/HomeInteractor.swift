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
    private var searchTokens = Set<AnyCancellable>()

    // MARK: - Inits
    init(repository: HomeRepositoryProtocol?) {
        self.repository = repository
    }
    
    func serachItem(searchText: String) {
        repository?.searchItem(offSet: 0, searchText: searchText)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Publisher stopped obversing")
                    case .failure(let error):
                        self.publisher?.send(HomePublisherResult.itemsSearchedWithFailure(error))
                    }
                }, receiveValue: { searchResult in
                    self.publisher?.send(HomePublisherResult.itemsSearchedWithSuccess(searchResult))
                }).store(in: &searchTokens)
    }
    
    func searchByCategory(_ category: HomeCategorySearch) {
        repository?.searchCategory(offSet: 0, category: category.stringValue)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Publisher stopped obversing")
                    case .failure(let error):
                        self.publisher?.send(HomePublisherResult.itemsSearchedWithFailure(error))
                    }
                }, receiveValue: { searchResult in
                    self.publisher?.send(HomePublisherResult.itemsSearchedWithSuccess(searchResult))
                }).store(in: &searchTokens)
    }
}
