import Combine
import Foundation
@testable import ArtistSearch

class SearchResultCloudDataSourceMock: SearchResultCloudDataSourceProtocol {
    // MARK: Properties

    var status: TransactionStatus = .success
    var mockData: SearchResultITunesDataMock

    // MARK: Lifecycle

    init(status: TransactionStatus, mockData: SearchResultITunesDataMock = .multipleResults) {
        self.status = status
        self.mockData = mockData
    }

    // MARK: Functions

    func searchArtist(searchText _: String, limit _: Int) -> Future<ArtistSearchResult, Error> {
        Future { promise in
            if self.status == .success {
                return promise(.success(self.mockData.searchResult))
            } else {
                return promise(.failure(CloudDataSourceDefaultError.httpError(code: 1002, message: "Test Error")))
            }
        }
    }

    func searchByMedia(mediaType _: String, searchText _: String, limit _: Int) -> Future<ArtistSearchResult, Error> {
        Future { promise in
            if self.status == .success {
                return promise(.success(self.mockData.searchResult))
            } else {
                return promise(.failure(CloudDataSourceDefaultError.httpError(code: 1002, message: "Test Error")))
            }
        }
    }
}
