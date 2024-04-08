//
//  SearchResultPresenter.swift
//  ProductSearch
//
//  Created by Luis Mejias on 17-03-22.
//  Copyright (c) 2022 Luis Mejías. All rights reserved.

import Combine
import UIKit

// MARK: - SearchResultPresenter

final class SearchResultPresenter: SearchResultPresenterProtocol {
    var searchResult: SearchResult
    var searchType: SearchType
    var searchCategory: HomeCategorySearch?
    var interactor: SearchResultInteractorProtocol?
    var router: SearchResultRouterProtocol?
    weak var view: SearchResultViewProtocol?
    private var searchItemsTokens = Set<AnyCancellable>()
    private var offSet: Int = 0
    var searchText = ""
    let pagingLength = 50

    // MARK: - Inits

    init(interactor: SearchResultInteractorProtocol?,
         router: SearchResultRouterProtocol?,
         searchResult: SearchResult,
         searchType: SearchType,
         searchCategory: HomeCategorySearch? = nil)
    {
        self.interactor = interactor
        self.router = router
        self.searchType = searchType
        self.searchResult = searchResult
        self.searchCategory = searchCategory
    }

    func viewDidLoad() {
        registerToInteractorPublisher()
    }

    func presentFilterTypeActionSheet() {
        router?.presentFilterTypeActionSheet()
    }

    func fetchNextOffSet() {
        offSet = offSet + pagingLength
        if searchType == .text {
            interactor?.fetchNextOffSet(offSet, searchText: searchText)
        } else {
            interactor?.fetchNextOffSet(offSet, category: searchCategory?.stringValue ?? "")
        }
    }

    func presentProductDetail(_ result: Result) {
        router?.presentProductDetail(result)
    }
}

// MARK: Interactor publisher subscription

private extension SearchResultPresenter {
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
                case let .displayNextOffSet(nextOffSetResults):
                    self?.view?.endLoadingIndicator()
                    self?.view?.displayNextOffSetResult(nextOffSetResults, searchType: self?.searchType ?? .text, searchCategory: self?.searchCategory ?? .vehicule)
                case let .displayNextOffSetFailed(error):
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

// MARK: Router Delegate

extension SearchResultPresenter: SearchResultRouterDelegate {
    func didSelectFilter(_ filter: FilterType) {
        guard let searchResults = searchResult.results else {
            return
        }

        switch filter {
        case .lowestPrice:
            searchResult.results = searchResults.sorted { $0.price ?? 0 < $1.price ?? 0 }
            view?.displaySearchResult()
        case .highestPrice:
            searchResult.results = searchResults.sorted { $0.price ?? 0 > $1.price ?? 0 }
        }

        view?.displaySearchResult()
    }
}
