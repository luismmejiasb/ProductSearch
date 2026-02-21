import Combine

// MARK: - SearchResultLocalDataSourceProtocol

protocol SearchResultLocalDataSourceProtocol {}

// MARK: - SearchResultCloudDataSourceProtocol

protocol SearchResultCloudDataSourceProtocol {
    func searchArtist(searchText: String, limit: Int) -> Future<ArtistSearchResult, Error>
    func searchByMedia(mediaType: String, searchText: String, limit: Int) -> Future<ArtistSearchResult, Error>
}

// MARK: - SearchResultRepositoryProtocol

protocol SearchResultRepositoryProtocol {
    var localDataSource: SearchResultLocalDataSourceProtocol? { get set }
    var cloudDataSource: SearchResultCloudDataSourceProtocol? { get set }

    func searchArtist(searchText: String, limit: Int) -> Future<ArtistSearchResult, Error>
    func searchByMedia(mediaType: String, searchText: String, limit: Int) -> Future<ArtistSearchResult, Error>
}
