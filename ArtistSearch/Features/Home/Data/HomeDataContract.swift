// MARK: - Local Data Source

import Combine

// MARK: - HomeLocalDataSourceProtocol

protocol HomeLocalDataSourceProtocol {}

// MARK: - HomeCloudDataSourceProtocol

protocol HomeCloudDataSourceProtocol {
    func searchArtist(searchText: String, limit: Int) -> Future<ArtistSearchResult, Error>
    func searchByMedia(mediaType: String, searchText: String, limit: Int) -> Future<ArtistSearchResult, Error>
}

// MARK: - HomeRepositoryProtocol

protocol HomeRepositoryProtocol {
    func searchArtist(searchText: String, limit: Int) -> Future<ArtistSearchResult, Error>
    func searchByMedia(mediaType: String, searchText: String, limit: Int) -> Future<ArtistSearchResult, Error>
}
