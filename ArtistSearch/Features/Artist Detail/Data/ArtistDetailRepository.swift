// MARK: - ArtistDetailRepository

final class ArtistDetailRepository: ArtistDetailRepositoryProtocol {
    // MARK: Properties

    private let localDataSource: ArtistDetailLocalDataSourceProtocol
    private let cloudDataSource: ArtistDetailCloudDataSourceProtocol

    // MARK: Lifecycle

    // MARK: - Inits

    init(
        localDataSource: ArtistDetailLocalDataSourceProtocol,
        cloudDataSource: ArtistDetailCloudDataSourceProtocol
    ) {
        self.localDataSource = localDataSource
        self.cloudDataSource = cloudDataSource
    }
}

