//
//  HomeFactory.swift
//  ProductSearch
//
//  Created by Luis Mejias on 15-03-22.
//  Copyright (c) 2022 Luis Mejías. All rights reserved.

// MARK: - HomeFactory

import Combine

final class HomeFactory: HomeFactoryProtocol {
    static func initialize() -> HomeViewController {
        let localDataSource = HomeLocalDataSource()
        let cloudDataSource = HomeCloudDataSource()
        let repository = HomeRepository(localDataSource: localDataSource, cloudDataSource: cloudDataSource)
        let interactor = HomeInteractor(repository: repository)
        let publisher = PassthroughSubject<HomePublisherResult, Error>()

        let router = HomeRouter()

        let presenter = HomePresenter(interactor: interactor, router: router)

        let viewController = HomeViewController()

        presenter.view = viewController
        viewController.presenter = presenter
        router.view = viewController
        interactor.publisher = publisher

        return viewController
    }
}
