//
//  SearchResultPresenter.swift
//  ProductSearch
//
//  Created by Luis Mejias on 17-03-22.
//  Copyright (c) 2022 Falabella FIF. All rights reserved.

import UIKit
import Combine

// MARK: - SearchResultPresenter
final class SearchResultPresenter: SearchResultPresenterProtocol {
    var searchResult: SearchResult
    internal var interactor: SearchResultInteractorProtocol?
    internal var router: SearchResultRouterProtocol?
    internal weak var view: SearchResultViewProtocol?
    private var searchItemsTokens = Set<AnyCancellable>()
    private var offSet: Int = 0
    var searchText = ""
    let pagingLength = 50

    // MARK: - Inits
    init(interactor: SearchResultInteractorProtocol?, router: SearchResultRouterProtocol?, searchResult: SearchResult) {
        self.interactor = interactor
        self.router = router
        self.searchResult = searchResult
    }
    
    func viewDidLoad() {
        registerToInteractorPublisher()
    }
    
    func presentFilterTypeActionSheet() {
        router?.presentFilterTypeActionSheet()
    }
    
    func fetchNextOffSet() {
        offSet = offSet + pagingLength
        interactor?.fetchNextOffSet(offSet, searchText: searchText)
    }
    
    func presentProductDetail(_ result: Result) {
        router?.presentProductDetail(result)
    }
}

// MARK: Interactor publisher subscription
private extension SearchResultPresenter {
    private func registerToInteractorPublisher() {
        interactor?.publisher?.sink(
            receiveCompletion: { [weak self] (completion) in
                switch completion {
                case .finished:
                    print("Publisher stopped obversing")
                case .failure(let error):
                    self?.view?.displayNextOffSetResultError(error)
                }
            }, receiveValue: { [weak self] (result) in
                switch result {
                case .displayNextOffSet(let nextOffSetResults):
                    self?.view?.displayNextOffSetResult(nextOffSetResults)
                case .displayNextOffSetFailed(let error):
                    self?.view?.displayNextOffSetResultError(error)
                }
            }).store(in: &searchItemsTokens)
    }
}


// MARK: Router Delegate
extension SearchResultPresenter: SearchResultRouterDelegate {
    func didSelectFilter(_ filter: FilterType) {
        guard let searchResults = searchResult.results else {
            return
        }

        switch filter {
        case .lowestPrice:
            self.searchResult.results = searchResults.sorted { $0.price ?? 0 < $1.price ?? 0}
            view?.displaySearchResult()
        case .highestPrice:
            self.searchResult.results = searchResults.sorted { $0.price ?? 0 > $1.price ?? 0}
        }
        
        view?.displaySearchResult()
    }
}
