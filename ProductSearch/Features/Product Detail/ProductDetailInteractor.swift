// MARK: - ProductDetailInteractor

final class ProductDetailInteractor: ProductDetailInteractorProtocol {
    // MARK: Properties

    var repository: ProductDetailRepositoryProtocol?

    // MARK: Lifecycle

    // MARK: - Inits

    init(repository: ProductDetailRepositoryProtocol?) {
        self.repository = repository
    }
}
