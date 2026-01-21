import Foundation
@testable import ProductSearch

class HomeLocalDataSourceMock: HomeLocalDataSourceProtocol {
    // MARK: Properties

    var status: TransactionStatus = .success

    // MARK: Lifecycle

    init() {}
}
