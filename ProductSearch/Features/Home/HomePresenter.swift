//
//  HomePresenter.swift
//  ProductSearch
//
//  Created by Luis Mejias on 15-03-22.
//  Copyright (c) 2022 Luis Mejías. All rights reserved.

import UIKit
import Combine

// MARK: - HomePresenter
final class HomePresenter: HomePresenterProtocol {
    internal var interactor: HomeInteractorProtocol?
    internal var router: HomeRouterProtocol?
    internal weak var view: HomeViewProtocol?
    private var searchItemsTokens = Set<AnyCancellable>()

    // MARK: - Inits
    init(interactor: HomeInteractorProtocol?, router: HomeRouterProtocol?) {
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        registerToInteractorPublisher()
    }
    
    func searchItem(searchText: String) {
        interactor?.serachItem(searchText: searchText)
    }
    
    func presentSearchResult(_ searchResult: SearchResult) {
        router?.presentSearchResult(searchResult)
    }
}

// MARK: Interactor publisher subscription
private extension HomePresenter {
    private func registerToInteractorPublisher() {
        interactor?.publisher?.sink(
            receiveCompletion: { [weak self] (completion) in
                switch completion {
                case .finished:
                    self?.view?.endLoadingIndicator()
                case .failure(let error):
                    self?.view?.endLoadingIndicator()
                    self?.displayError(error)
                }
            }, receiveValue: { [weak self] (result) in
                switch result {
                case .itemsSearchedWithSuccess(let searchResults):
                    self?.view?.endLoadingIndicator()
                    self?.view?.displaySearchResult(searchResults)
                case .itemsSearchedWithFailure(let error):
                    self?.view?.endLoadingIndicator()
                    self?.displayError(error)
                }
            }).store(in: &searchItemsTokens)
    }
    
    private func displayError(_ error: Error) {
        if let error = error as? HomeCloudDataSourceDefaultError {
            switch error {
            case .httpError:
                router?.displayAlert(title: "Error", message: "Tuvimos un error con nuestros servicios. Por favor, intenta nuevamente más tarde.")
            default:
                router?.displayAlert(title: "Error en tu busqueda", message: "No pudimos continuar con tu búsqueda. Por favor, intento nuevamente o con otra descripción de tu producto")
            }
        }
    }
}
