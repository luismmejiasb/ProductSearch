import Combine

// MARK: - SearchResultLocalDataSourceProtocol

protocol SearchResultLocalDataSourceProtocol {}

// MARK: - SearchResultCloudDataSourceProtocol

protocol SearchResultCloudDataSourceProtocol {
    func searchItem(offSet: Int, searchText: String) -> Future<SearchResult, Error>

    func searchCategory(offSet: Int, category: String) -> Future<SearchResult, Error>
}

// MARK: - SearchResultRepositoryProtocol

protocol SearchResultRepositoryProtocol {
    var localDataSource: SearchResultLocalDataSourceProtocol? { get set }
    var cloudDataSource: SearchResultCloudDataSourceProtocol? { get set }

    func searchItem(offSet: Int, searchText: String) -> Future<SearchResult, Error>
    func searchCategory(offSet: Int, category: String) -> Future<SearchResult, Error>
}
