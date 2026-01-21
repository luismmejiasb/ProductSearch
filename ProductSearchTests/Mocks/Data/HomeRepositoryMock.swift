import Combine
import Foundation
@testable import ProductSearch

class HomeRepositoryMock: HomeRepositoryProtocol {
    // MARK: Properties

    var functionsCalled = [String]()
    var localDataSource: HomeLocalDataSourceProtocol?
    var cloudDataSource: HomeCloudDataSourceProtocol?

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

    func searchItem(offSet: Int, searchText: String) -> Future<SearchResult, Error> {
        functionsCalled.append(#function)
        return (cloudDataSource?.searchItem(offSet: offSet, searchText: searchText))!
    }

    func searchCategory(offSet: Int, category: String) -> Future<SearchResult, Error> {
        functionsCalled.append(#function)
        return (cloudDataSource?.searchCategory(offSet: offSet, category: category))!
    }
}
