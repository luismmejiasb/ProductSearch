import Combine
import Foundation
@testable import ProductSearch

// MARK: - SearchResultCloudDataSourceMock

class SearchResultCloudDataSourceMock: SearchResultCloudDataSourceProtocol {
    // MARK: Properties

    var status: TransactionStatus
    var mockData: SearchResultMLCDataMock

    // MARK: Lifecycle

    init(status: TransactionStatus, mockData: SearchResultMLCDataMock = .multipleResults) {
        self.status = status
        self.mockData = mockData
    }

    // MARK: Functions

    func searchItem(offSet _: Int, searchText _: String) -> Future<SearchResult, Error> {
        Future { [weak self] promise in
            guard let self else { return }
            if self.status == .success {
                guard let result = self.mockData.searchResult else {
                    promise(.failure(CloudDataSourceDefaultError.responseCannotBeParsed))
                    return
                }
                promise(.success(result))
            } else {
                promise(.failure(CloudDataSourceDefaultError.httpError(code: 1002, message: "Test Error")))
            }
        }
    }

    func searchCategory(offSet _: Int, category _: String) -> Future<SearchResult, Error> {
        Future { [weak self] promise in
            guard let self else { return }
            if self.status == .success {
                guard let result = self.mockData.searchResult else {
                    promise(.failure(CloudDataSourceDefaultError.responseCannotBeParsed))
                    return
                }
                promise(.success(result))
            } else {
                promise(.failure(CloudDataSourceDefaultError.httpError(code: 1002, message: "Test Error")))
            }
        }
    }
}
