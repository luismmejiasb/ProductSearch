import Combine

// MARK: - SearchResultFactory

@MainActor
final class SearchResultFactory: SearchResultFactoryProtocol {
    static func initialize(
        homeSearchResult: SearchResult,
        searchType: SearchType,
        searchCategory: HomeCategorySearch
    ) -> SearchResultViewController {
        let localDataSource = SearchResultLocalDataSource()
        let cloudDataSource = SearchResultCloudDataSource()
        let repository = SearchResultRepository(localDataSource: localDataSource, cloudDataSource: cloudDataSource)
        let interactor = SearchResultInteractor(repository: repository, searchType: searchType)
        let publisher = PassthroughSubject<SearchResultPublisherResult, Error>()

        let router = SearchResultRouter()

        let presenter = SearchResultPresenter(
            interactor: interactor,
            router: router,
            searchResult: homeSearchResult,
            searchType: searchType,
            searchCategory: searchCategory,
            searchText: homeSearchResult.query ?? ""
        )

        let viewController = SearchResultViewController()

        presenter.view = viewController
        viewController.presenter = presenter
        router.view = viewController
        interactor.publisher = publisher
        router.delegate = presenter as SearchResultRouterDelegate

        return viewController
    }
}
