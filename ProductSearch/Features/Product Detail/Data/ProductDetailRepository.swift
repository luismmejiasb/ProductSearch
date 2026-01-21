// MARK: - ProductDetailRepository

final class ProductDetailRepository: ProductDetailRepositoryProtocol {
    // MARK: Properties

    private let localDataSource: ProductDetailLocalDataSourceProtocol
    private let cloudDataSource: ProductDetailCloudDataSourceProtocol

    // MARK: Lifecycle

    // MARK: - Inits

    init(
        localDataSource: ProductDetailLocalDataSourceProtocol,
        cloudDataSource: ProductDetailCloudDataSourceProtocol
    ) {
        self.localDataSource = localDataSource
        self.cloudDataSource = cloudDataSource
    }
}
