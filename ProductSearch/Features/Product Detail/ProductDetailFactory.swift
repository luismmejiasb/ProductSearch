// MARK: - ProductDetailFactory

@MainActor
final class ProductDetailFactory: ProductDetailFactoryProtocol {
    static func initialize(product: Result) -> ProductDetailViewController {
        let localDataSource = ProductDetailLocalDataSource()
        let cloudDataSource = ProductDetailCloudDataSource()
        let repository = ProductDetailRepository(localDataSource: localDataSource, cloudDataSource: cloudDataSource)
        let interactor = ProductDetailInteractor(repository: repository)

        let router = ProductDetailRouter()

        let presenter = ProductDetailPresenter(interactor: interactor, router: router, product: product)

        let viewController = ProductDetailViewController()

        presenter.view = viewController
        viewController.presenter = presenter
        router.view = viewController

        return viewController
    }
}
