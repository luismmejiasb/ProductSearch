import Combine
import Foundation
@testable import ArtistSearch

class HomeRepositoryMock: HomeRepositoryProtocol {
    // MARK: Properties

    var functionsCalled = [String]()
    var localDataSource: HomeLocalDataSourceProtocol?
    var cloudDataSource: HomeCloudDataSourceProtocol?
    var lastOffSet: Int = -1
    var lastSearchText: String = ""
    var lastMediaType: String = ""

    private let status: TransactionStatus

    // MARK: Lifecycle

    init(
        status: TransactionStatus,
        localDataSource: HomeLocalDataSourceProtocol?,
        cloudDataSource: HomeCloudDataSourceProtocol?
    ) {
        self.status = status
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
