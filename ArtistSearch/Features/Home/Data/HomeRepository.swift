// MARK: - HomeRepository

import Combine

final class HomeRepository: HomeRepositoryProtocol {
    // MARK: Properties

    private let localDataSource: HomeLocalDataSourceProtocol
    private let cloudDataSource: HomeCloudDataSourceProtocol

    // MARK: Lifecycle

    // MARK: - Inits

    init(localDataSource: HomeLocalDataSourceProtocol, cloudDataSource: HomeCloudDataSourceProtocol) {
        self.localDataSource = localDataSource
        self.cloudDataSource = cloudDataSource
    }

    // MARK: Functions

    func searchArtist(searchText: String, limit: Int) -> Future<ArtistSearchResult, Error> {
        cloudDataSource.searchArtist(searchText: searchText, limit: limit)
    }

    func searchByMedia(mediaType: String, searchText: String, limit: Int) -> Future<ArtistSearchResult, Error> {
        cloudDataSource.searchByMedia(mediaType: mediaType, searchText: searchText, limit: limit)
    }
}
