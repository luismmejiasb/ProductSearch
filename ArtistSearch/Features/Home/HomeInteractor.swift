// MARK: - HomeInteractor

import Combine

final class HomeInteractor: HomeInteractorProtocol {
    // MARK: Properties

    let publisher: PassthroughSubject<HomePublisherResult, Error>

    private let repository: HomeRepositoryProtocol?
    private var searchTokens = Set<AnyCancellable>()

    // MARK: - Inits

    init(repository: HomeRepositoryProtocol?, publisher: PassthroughSubject<HomePublisherResult, Error>) {
        self.repository = repository
        self.publisher = publisher
    }

    // MARK: Functions

    func searchArtist(searchText: String) {
        repository?.searchArtist(searchText: searchText, limit: 50)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.publisher.send(HomePublisherResult.itemsSearchedWithFailure(error))
                    }
                }, receiveValue: { [weak self] searchResult in
                    self?.publisher.send(HomePublisherResult.itemsSearchedWithSuccess(searchResult: searchResult))
                }
            ).store(in: &searchTokens)
    }

    func searchByCategory(_ category: HomeCategorySearch) {
        repository?.searchByMedia(mediaType: category.mediaType, searchText: category.uiTitle, limit: 50)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.publisher.send(HomePublisherResult.categorySearchedWithFailure(error))
                    }
                }, receiveValue: { [weak self] searchResult in
                    self?.publisher.send(HomePublisherResult.categorySearchedWithSuccess(searchResult: searchResult, searchedCategory: category))
                }
            ).store(in: &searchTokens)
    }
}
