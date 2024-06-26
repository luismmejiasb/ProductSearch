//
//  HomePresenter.swift
//  ProductSearch
//
//  Created by Luis Mejias on 15-03-22.
//  Copyright (c) 2022 Luis Mejías. All rights reserved.

import Combine
import UIKit

// MARK: - HomePresenter

final class HomePresenter: HomePresenterProtocol {
    var interactor: HomeInteractorProtocol?
    var router: HomeRouterProtocol?
    weak var view: HomeViewControllerProtocol?
    private var searchItemsTokens = Set<AnyCancellable>()

    // MARK: - Inits

    init(interactor: HomeInteractorProtocol?, router: HomeRouterProtocol?) {
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        registerToInteractorPublisher()
    }

    func presentSearchResult(_ searchResult: SearchResult, searchType: SearchType, searchCategory: HomeCategorySearch? = nil) {
        router?.presentSearchResult(searchResult, searchType: searchType, searchCategory: searchCategory)
    }

    func searchItem(searchText: String) {
        interactor?.serachItem(searchText: searchText)
    }

    func searchByCategory(_ category: HomeCategorySearch) {
        interactor?.searchByCategory(category)
    }
}

// MARK: Interactor publisher subscription

private extension HomePresenter {
    private func registerToInteractorPublisher() {
        interactor?.publisher?.sink(
            receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.view?.endLoadingIndicator()
                case let .failure(error):
                    self?.view?.endLoadingIndicator()
                    self?.displayError(error)
                }
            }, receiveValue: { [weak self] result in
                switch result {
                case let .itemsSearchedWithSuccess(searchResult):
                    self?.view?.endLoadingIndicator()
                    self?.view?.displaySearchResult(searchResult, searchType: .text, searchCategory: nil)
                case let .itemsSearchedWithFailure(error):
                    self?.view?.endLoadingIndicator()
                    self?.displayError(error)
                case let .categorySearchedWithSuccess(searchResult, searchedCategory):
                    self?.view?.endLoadingIndicator()
                    self?.view?.displaySearchResult(searchResult, searchType: .category, searchCategory: searchedCategory)
                case let .categorySearchedWithFailure(error):
                    self?.view?.endLoadingIndicator()
                    self?.displayError(error)
                }
            }
        ).store(in: &searchItemsTokens)
    }

    private func displayError(_ error: Error) {
        if let error = error as? CloudDataSourceDefaultError {
            switch error {
            case .httpError:
                router?.displayAlert(title: "Error", message: "Tuvimos un error con nuestros servicios. Por favor, intenta nuevamente más tarde.")
            default:
                router?.displayAlert(title: "Error en tu busqueda", message: "No pudimos continuar con tu búsqueda. Por favor, intento nuevamente o con otra descripción de tu producto")
            }
        }
    }
}
