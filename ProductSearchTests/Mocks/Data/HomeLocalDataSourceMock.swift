import Foundation
@testable import ArtistSearch

class HomeLocalDataSourceMock: HomeLocalDataSourceProtocol {
    // MARK: Properties

    var status: TransactionStatus = .success

    // MARK: Lifecycle

    init() {}
}
