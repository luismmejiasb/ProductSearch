// MARK: - ProductDetailLocalDataSourceProtocol

protocol ProductDetailLocalDataSourceProtocol {}

// MARK: - ProductDetailCloudDataSourceProtocol

protocol ProductDetailCloudDataSourceProtocol {}

// MARK: - ProductDetailRepositoryProtocol

protocol ProductDetailRepositoryProtocol {
    var localDataSource: ProductDetailLocalDataSourceProtocol? { get set }
    var cloudDataSource: ProductDetailCloudDataSourceProtocol? { get set }
}
