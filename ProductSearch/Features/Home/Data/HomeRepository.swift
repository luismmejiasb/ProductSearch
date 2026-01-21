// MARK: - HomeRepository

import Combine

final class HomeRepository: HomeRepositoryProtocol {
    // MARK: Properties

    private let localDataSource: HomeLocalDataSourceProtocol?
    private let cloudDataSource: HomeCloudDataSourceProtocol?

    // MARK: Lifecycle

    // MARK: - Inits

    init(localDataSource: HomeLocalDataSourceProtocol?, cloudDataSource: HomeCloudDataSourceProtocol?) {
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
