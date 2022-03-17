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
    internal var interactor: SearchResultInteractorProtocol?
    internal var router: SearchResultRouterProtocol?
    internal weak var view: SearchResultViewProtocol?
    private var searchItemsTokens = Set<AnyCancellable>()

    // MARK: - Inits
    init(interactor: SearchResultInteractorProtocol?, router: SearchResultRouterProtocol?) {
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        
    }
    
    func presentFilterTypeActionSheet() {
        router?.presentFilterTypeActionSheet()
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
