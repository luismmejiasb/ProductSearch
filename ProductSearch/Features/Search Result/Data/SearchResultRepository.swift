import Combine

// MARK: - SearchResultRepository

final class SearchResultRepository: SearchResultRepositoryProtocol {
    // MARK: Properties

    var localDataSource: SearchResultLocalDataSourceProtocol?
    var cloudDataSource: SearchResultCloudDataSourceProtocol?

    // MARK: Lifecycle

    // MARK: - Inits

    init(localDataSource: SearchResultLocalDataSourceProtocol?, cloudDataSource: SearchResultCloudDataSourceProtocol?) {
        self.localDataSource = localDataSource
        self.cloudDataSource = cloudDataSource
    }

    // MARK: Functions

    func searchItem(offSet: Int, searchText: String) -> Future<SearchResult, Error> {
        guard let cloudDataSource else {
            return Future { promise in
                promise(.failure(CloudDataSourceDefaultError.unwrappableValue))
            }
        }

        return cloudDataSource.searchItem(offSet: offSet, searchText: searchText)
    }

    func searchCategory(offSet: Int, category: String) -> Future<SearchResult, Error> {
        guard let cloudDataSource else {
            return Future { promise in
                promise(.failure(CloudDataSourceDefaultError.unwrappableValue))
            }
        }

        return cloudDataSource.searchCategory(offSet: offSet, category: category)
    }
}
