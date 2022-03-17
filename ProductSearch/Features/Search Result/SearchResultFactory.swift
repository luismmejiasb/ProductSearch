//
//  SearchResultFactory.swift
//  ProductSearch
//
//  Created by Luis Mejias on 17-03-22.
//  Copyright (c) 2022 Falabella FIF. All rights reserved.

// MARK: - SearchResultFactory
final class SearchResultFactory: SearchResultFactoryProtocol {
    static func initialize(homeSearchResult: SearchResult) -> SearchResultViewController {
        let localDataSource = SearchResultLocalDataSource()
        let cloudDataSource = SearchResultCloudDataSource()
        let repository = SearchResultRepository(localDataSource: localDataSource, cloudDataSource: cloudDataSource)
        let interactor = SearchResultInteractor(repository: repository)

        let router = SearchResultRouter()

        let presenter = SearchResultPresenter(interactor: interactor, router: router)

        let viewController = SearchResultViewController()
        viewController.searchResult = homeSearchResult

        presenter.view = viewController
        viewController.presenter = presenter
        router.view = viewController

        return viewController
    }
}
