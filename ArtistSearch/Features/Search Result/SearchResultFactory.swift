import Combine

// MARK: - SearchResultFactory

@MainActor
final class SearchResultFactory: SearchResultFactoryProtocol {
    static func initialize(
        homeSearchResult: ArtistSearchResult,
        searchType: SearchType,
        searchCategory: HomeCategorySearch
    ) -> SearchResultViewController {
        let localDataSource = SearchResultLocalDataSource()
        let cloudDataSource = SearchResultCloudDataSource()
        let repository = SearchResultRepository(localDataSource: localDataSource, cloudDataSource: cloudDataSource)
        let publisher = PassthroughSubject<SearchResultPublisherResult, Error>()
        let interactor = SearchResultInteractor(repository: repository, searchType: searchType, publisher: publisher)

        let router = SearchResultRouter()

        let presenter = SearchResultPresenter(
            interactor: interactor,
            router: router,
            searchResult: homeSearchResult,
            searchType: searchType,
            searchCategory: searchCategory,
            searchText: homeSearchResult.searchText ?? ""
        )

        let viewController = SearchResultViewController()

        presenter.view = viewController
        viewController.presenter = presenter
        router.view = viewController
        router.delegate = presenter as SearchResultRouterDelegate

        return viewController
    }
}
