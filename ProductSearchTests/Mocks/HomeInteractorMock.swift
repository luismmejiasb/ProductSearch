//
//  HomeInteractorMock.swift
//  Alamofire
//
//  Created by Luis Mejias on 22-03-22.
//

import Foundation
import Combine
@testable import ProductSearch

class HomeInteractorMock: HomeInteractorProtocol {
    var repository: HomeRepositoryProtocol?
    var publisher: PassthroughSubject<HomePublisherResult, Error>?
    var functionsCalled = [String]()
    private var searchTokens = Set<AnyCancellable>()

    init(repository: HomeRepositoryProtocol?) {
        self.repository = repository
    }

    func serachItem(searchText: String) {
        functionsCalled.append(#function)

        repository?.searchItem(offSet: 0, searchText: searchText)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.publisher?.send(HomePublisherResult.itemsSearchedWithFailure(error))
                    }
                }, receiveValue: { searchResult in
                    self.publisher?.send(HomePublisherResult.itemsSearchedWithSuccess(searchResult: searchResult))
                }).store(in: &searchTokens)
    }
    
    func searchByCategory(_ category: HomeCategorySearch) {
        functionsCalled.append(#function)
        
        repository?.searchCategory(offSet: 0, category: HomeCategorySearch.realState.stringValue)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.publisher?.send(HomePublisherResult.itemsSearchedWithFailure(error))
                    }
                }, receiveValue: { searchResult in
                    self.publisher?.send(HomePublisherResult.itemsSearchedWithSuccess(searchResult: searchResult))
                }).store(in: &searchTokens)
    }
}
