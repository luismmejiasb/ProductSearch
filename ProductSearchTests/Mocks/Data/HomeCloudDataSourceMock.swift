import Combine
import Foundation
@testable import ProductSearch

class HomeCloudDataSourceMock: HomeCloudDataSourceProtocol {
    // MARK: Properties

    var status: TransactionStatus = .success

    // MARK: Lifecycle

    init(status: TransactionStatus) {
        self.status = status
    }

    // MARK: Functions

    func searchItem(offSet _: Int, searchText _: String) -> Future<SearchResult, Error> {
        Future { promise in
            if self.status == .success {
                return promise(.success(HomeMLCDataMock.homeSearchItem.searchDefaultResult!))
            } else {
                return promise(.failure(CloudDataSourceDefaultError.httpError(code: 1002, message: "Test Error")))
            }
        }
    }

    func searchCategory(offSet _: Int, category _: String) -> Future<SearchResult, Error> {
        Future { promise in
            if self.status == .success {
                return promise(.success(HomeMLCDataMock.homeSearchItem.searchDefaultResult!))
            } else {
                return promise(.failure(CloudDataSourceDefaultError.httpError(code: 1002, message: "Test Error")))
            }
        }
    }
}
