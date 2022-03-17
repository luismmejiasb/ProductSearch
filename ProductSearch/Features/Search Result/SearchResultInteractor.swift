//
//  SearchResultInteractor.swift
//  ProductSearch
//
//  Created by Luis Mejias on 17-03-22.
//  Copyright (c) 2022 Falabella FIF. All rights reserved.
import Combine

// MARK: - SearchResultInteractor
final class SearchResultInteractor: SearchResultInteractorProtocol {
	var repository: SearchResultRepositoryProtocol?
    weak var delegate: SearchResultInteractorDelegate?
    private var searchTokens = Set<AnyCancellable>()
    var publisher: PassthroughSubject<SearchResultPublisherResult, Error>?

    // MARK: - Inits
    init(repository: SearchResultRepositoryProtocol?) {
        self.repository = repository
    }
    
    func serachItem(offSet: Int, searchText: String) {
        repository?.searchItem(offSet: offSet, searchText: searchText)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Publisher stopped obversing")
                    case .failure(let error):
                        self.publisher?.send(SearchResultPublisherResult.displayNextOffSetFailed(error))
                    }
                }, receiveValue: { nextOffSetResult in
                    self.publisher?.send(SearchResultPublisherResult.displayNextOffSet(nextOffSetResult))
                }).store(in: &searchTokens)
    }
}
