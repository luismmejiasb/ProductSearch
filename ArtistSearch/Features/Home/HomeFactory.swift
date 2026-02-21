// MARK: - HomeFactory

import Combine

@MainActor
final class HomeFactory: HomeFactoryProtocol {
    static func initialize() -> HomeViewController {
        let localDataSource = HomeLocalDataSource()
        let cloudDataSource = HomeCloudDataSource()
        let repository = HomeRepository(localDataSource: localDataSource, cloudDataSource: cloudDataSource)
        let publisher = PassthroughSubject<HomePublisherResult, Error>()
        let interactor = HomeInteractor(repository: repository, publisher: publisher)

        let router = HomeRouter()
        let presenter = HomePresenter(interactor: interactor, router: router)
        let viewController = HomeViewController()

        presenter.view = viewController
        viewController.presenter = presenter
        router.view = viewController

        return viewController
    }
}
