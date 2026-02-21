import Combine
import Foundation
@testable import ArtistSearch

class HomeCloudDataSourceMock: HomeCloudDataSourceProtocol {
    // MARK: Properties

    var status: TransactionStatus = .success

    // MARK: Lifecycle

    init(status: TransactionStatus) {
        self.status = status
    }

    // MARK: Functions

    func searchArtist(searchText _: String, limit _: Int) -> Future<ArtistSearchResult, Error> {
        Future { promise in
            if self.status == .success {
                return promise(.success(HomeITunesDataMock.homeSearchArtist.searchDefaultResult))
            } else {
                return promise(.failure(CloudDataSourceDefaultError.httpError(code: 1002, message: "Test Error")))
            }
        }
    }

    func searchByMedia(mediaType _: String, searchText _: String, limit _: Int) -> Future<ArtistSearchResult, Error> {
        Future { promise in
            if self.status == .success {
                return promise(.success(HomeITunesDataMock.homeSearchArtist.searchDefaultResult))
            } else {
                return promise(.failure(CloudDataSourceDefaultError.httpError(code: 1002, message: "Test Error")))
            }
        }
    }
}
