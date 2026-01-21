import Combine

// MARK: - SearchResultFactory

@MainActor
final class SearchResultFactory: SearchResultFactoryProtocol {
    static func initialize(homeSearchResult: SearchResult, searchType: SearchType, searchCategory: HomeCategorySearch? = nil) -> SearchResultViewController {
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
            searchType: searchType
        )

        let viewController = SearchResultViewController()

        presenter.view = viewController
        presenter.searchCategory = searchCategory
        presenter.searchText = homeSearchResult.query ?? ""
        viewController.presenter = presenter
        router.view = viewController
        interactor.publisher = publisher
        router.delegate = presenter as SearchResultRouterDelegate

        return viewController
    }
}
