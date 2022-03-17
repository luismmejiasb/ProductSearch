//
//  SearchResultFactory.swift
//  ProductSearch
//
//  Created by Luis Mejias on 17-03-22.
//  Copyright (c) 2022 Falabella FIF. All rights reserved.
import Combine

// MARK: - SearchResultFactory
final class SearchResultFactory: SearchResultFactoryProtocol {
    static func initialize(homeSearchResult: SearchResult) -> SearchResultViewController {
        let localDataSource = SearchResultLocalDataSource()
        let cloudDataSource = SearchResultCloudDataSource()
        let repository = SearchResultRepository(localDataSource: localDataSource, cloudDataSource: cloudDataSource)
        let interactor = SearchResultInteractor(repository: repository)
        let publisher = PassthroughSubject<SearchResultPublisherResult, Error>()

        let router = SearchResultRouter()

        let presenter = SearchResultPresenter(interactor: interactor, router: router)

        let viewController = SearchResultViewController()
        viewController.searchResult = homeSearchResult

        presenter.view = viewController
        presenter.searchText = homeSearchResult.query ?? ""
        viewController.presenter = presenter
        router.view = viewController
        interactor.publisher = publisher

        return viewController
    }
}
