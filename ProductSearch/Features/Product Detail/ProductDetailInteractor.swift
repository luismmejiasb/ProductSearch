// MARK: - ProductDetailInteractor

final class ProductDetailInteractor: ProductDetailInteractorProtocol {
    // MARK: Properties

    private let repository: ProductDetailRepositoryProtocol

    // MARK: Lifecycle

    // MARK: - Inits

    init(repository: ProductDetailRepositoryProtocol) {
        self.repository = repository
    }
}
