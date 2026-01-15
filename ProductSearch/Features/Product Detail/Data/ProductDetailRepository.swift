// MARK: - ProductDetailRepository

final class ProductDetailRepository: ProductDetailRepositoryProtocol {
    // MARK: Properties

    var localDataSource: ProductDetailLocalDataSourceProtocol?
    var cloudDataSource: ProductDetailCloudDataSourceProtocol?

    // MARK: Lifecycle

    // MARK: - Inits

    init(localDataSource: ProductDetailLocalDataSourceProtocol?, cloudDataSource: ProductDetailCloudDataSourceProtocol?) {
        self.localDataSource = localDataSource
        self.cloudDataSource = cloudDataSource
    }
}
