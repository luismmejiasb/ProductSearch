import Combine

// MARK: - SearchResultRepository

final class SearchResultRepository: SearchResultRepositoryProtocol {
    // MARK: Properties

    var localDataSource: SearchResultLocalDataSourceProtocol?
    var cloudDataSource: SearchResultCloudDataSourceProtocol?

    // MARK: Lifecycle

    // MARK: - Inits

    init(localDataSource: SearchResultLocalDataSourceProtocol?, cloudDataSource: SearchResultCloudDataSourceProtocol?) {
        self.localDataSource = localDataSource
        self.cloudDataSource = cloudDataSource
    }

    // MARK: Functions

    func searchArtist(searchText: String, limit: Int) -> Future<ArtistSearchResult, Error> {
        guard let cloudDataSource else {
            return Future { promise in
                promise(.failure(CloudDataSourceDefaultError.unwrappableValue))
            }
        }
        return cloudDataSource.searchArtist(searchText: searchText, limit: limit)
    }

    func searchByMedia(mediaType: String, searchText: String, limit: Int) -> Future<ArtistSearchResult, Error> {
        guard let cloudDataSource else {
            return Future { promise in
                promise(.failure(CloudDataSourceDefaultError.unwrappableValue))
            }
        }
        return cloudDataSource.searchByMedia(mediaType: mediaType, searchText: searchText, limit: limit)
    }
}
