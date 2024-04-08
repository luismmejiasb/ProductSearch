//
//  SearchResultInteractor.swift
//  ProductSearch
//
//  Created by Luis Mejias on 17-03-22.
//  Copyright (c) 2022 Luis Mejías. All rights reserved.
import Combine

// MARK: - SearchResultInteractor

final class SearchResultInteractor: SearchResultInteractorProtocol {
    var repository: SearchResultRepositoryProtocol?
    private var searchTokens = Set<AnyCancellable>()
    var publisher: PassthroughSubject<SearchResultPublisherResult, Error>?
    var searchType: SearchType

    // MARK: - Inits

    init(repository: SearchResultRepositoryProtocol?, searchType: SearchType) {
        self.repository = repository
        self.searchType = searchType
    }

    func fetchNextOffSet(_ offSet: Int, searchText: String) {
        repository?.searchItem(offSet: offSet, searchText: searchText)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case let .failure(error):
                        self.publisher?.send(SearchResultPublisherResult.displayNextOffSetFailed(error))
                    }
                }, receiveValue: { nextOffSetResult in
                    self.publisher?.send(SearchResultPublisherResult.displayNextOffSet(searchResult: nextOffSetResult))
                }
            ).store(in: &searchTokens)
    }

    func fetchNextOffSet(_ offSet: Int, category: String) {
        repository?.searchCategory(offSet: offSet, category: category)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case let .failure(error):
                        self.publisher?.send(SearchResultPublisherResult.displayNextOffSetFailed(error))
                    }
                }, receiveValue: { nextOffSetResult in
                    self.publisher?.send(SearchResultPublisherResult.displayNextOffSet(searchResult: nextOffSetResult))
                }
            ).store(in: &searchTokens)
    }
}
