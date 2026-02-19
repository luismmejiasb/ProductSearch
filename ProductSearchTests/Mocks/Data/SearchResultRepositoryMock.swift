import Combine
import Foundation
@testable import ProductSearch

// MARK: - SearchResultRepositoryMock

class SearchResultRepositoryMock: SearchResultRepositoryProtocol {
    // MARK: Properties

    var localDataSource: SearchResultLocalDataSourceProtocol?
    var cloudDataSource: SearchResultCloudDataSourceProtocol?
    var functionsCalled = [String]()
    var lastOffSet: Int = 0
    var lastSearchText: String = ""
    var lastCategory: String = ""

    // MARK: Lifecycle

    init(
        status: TransactionStatus,
        localDataSource: SearchResultLocalDataSourceProtocol?,
        cloudDataSource: SearchResultCloudDataSourceProtocol?
    ) {
        self.localDataSource = localDataSource
        self.cloudDataSource = cloudDataSource
    }

    // MARK: Functions

    func searchItem(offSet: Int, searchText: String) -> Future<SearchResult, Error> {
        functionsCalled.append(#function)
        lastOffSet = offSet
        lastSearchText = searchText
        return cloudDataSource!.searchItem(offSet: offSet, searchText: searchText)
    }

    func searchCategory(offSet: Int, category: String) -> Future<SearchResult, Error> {
        functionsCalled.append(#function)
        lastOffSet = offSet
        lastCategory = category
        return cloudDataSource!.searchCategory(offSet: offSet, category: category)
    }
}
