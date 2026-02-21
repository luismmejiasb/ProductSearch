// MARK: - ArtistDetailFactory

@MainActor
final class ArtistDetailFactory: ArtistDetailFactoryProtocol {
    static func initialize(artist: ArtistResult) -> ArtistDetailViewController {
        let localDataSource = ArtistDetailLocalDataSource()
        let cloudDataSource = ArtistDetailCloudDataSource()
        let repository = ArtistDetailRepository(localDataSource: localDataSource, cloudDataSource: cloudDataSource)
        let interactor = ArtistDetailInteractor(repository: repository)

        let router = ArtistDetailRouter()

        let presenter = ArtistDetailPresenter(interactor: interactor, router: router, artist: artist)

        let viewController = ArtistDetailViewController()

        presenter.view = viewController
        viewController.presenter = presenter
        router.view = viewController

        return viewController
    }
}

