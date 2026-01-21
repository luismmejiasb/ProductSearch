import Combine
import Foundation
@testable import ProductSearch

class HomeInteractorMock: HomeInteractorProtocol {
    // MARK: Properties

    var repository: HomeRepositoryProtocol?
    var publisher: PassthroughSubject<HomePublisherResult, Error>?
    var functionsCalled = [String]()

    private var searchTokens = Set<AnyCancellable>()

    // MARK: Lifecycle

    init(repository: HomeRepositoryProtocol?) {
        self.repository = repository
    }

    // MARK: Functions

    func serachItem(searchText: String) {
        functionsCalled.append(#function)

        repository?.searchItem(offSet: 0, searchText: searchText)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.publisher?.send(HomePublisherResult.itemsSearchedWithFailure(error))
                    }
                }, receiveValue: { searchResult in
                    self.publisher?.send(HomePublisherResult.itemsSearchedWithSuccess(searchResult: searchResult))
                }
            ).store(in: &searchTokens)
    }

    func searchByCategory(_ category: HomeCategorySearch) {
        functionsCalled.append(#function)

        repository?.searchCategory(offSet: 0, category: HomeCategorySearch.realState.stringValue)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.publisher?.send(HomePublisherResult.itemsSearchedWithFailure(error))
                    }
                }, receiveValue: { searchResult in
                    self.publisher?.send(HomePublisherResult.itemsSearchedWithSuccess(searchResult: searchResult))
                }
            ).store(in: &searchTokens)
    }
}
