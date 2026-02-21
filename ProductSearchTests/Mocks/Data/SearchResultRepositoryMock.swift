import Combine
import Foundation
@testable import ArtistSearch

class SearchResultRepositoryMock: SearchResultRepositoryProtocol {
    // MARK: Properties

    var functionsCalled = [String]()
    var localDataSource: SearchResultLocalDataSourceProtocol?
    var cloudDataSource: SearchResultCloudDataSourceProtocol?
    var lastOffSet: Int = -1
    var lastSearchText: String = ""
    var lastMediaType: String = ""

    // MARK: Lifecycle

    init(
        localDataSource: SearchResultLocalDataSourceProtocol?,
        cloudDataSource: SearchResultCloudDataSourceProtocol?
    ) {
        self.cloudDataSource = cloudDataSource
        self.localDataSource = localDataSource
    }

    // MARK: Functions

    func searchArtist(searchText: String, limit: Int) -> Future<ArtistSearchResult, Error> {
        functionsCalled.append(#function)
        lastSearchText = searchText
        guard let cloudDataSource else {
            return Future { $0(.failure(RepositoryMockError.nilValue)) }
        }
        return cloudDataSource.searchArtist(searchText: searchText, limit: limit)
    }

    func searchByMedia(mediaType: String, searchText: String, limit: Int) -> Future<ArtistSearchResult, Error> {
        functionsCalled.append(#function)
        lastMediaType = mediaType
        lastSearchText = searchText
        guard let cloudDataSource else {
            return Future { $0(.failure(RepositoryMockError.nilValue)) }
        }
        return cloudDataSource.searchByMedia(mediaType: mediaType, searchText: searchText, limit: limit)
    }
}
