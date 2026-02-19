import Combine
import Foundation
@testable import ProductSearch

// MARK: - SearchResultInteractorMock

class SearchResultInteractorMock: SearchResultInteractorProtocol {
    // MARK: Properties

    var publisher: PassthroughSubject<SearchResultPublisherResult, Error>?
    var functionsCalled = [String]()
    var lastOffSet: Int = 0
    var lastSearchText: String = ""
    var lastCategory: String = ""

    private let repository: SearchResultRepositoryProtocol?
    private var searchTokens = Set<AnyCancellable>()

    // MARK: Lifecycle

    init(repository: SearchResultRepositoryProtocol?) {
        self.repository = repository
    }

    // MARK: Functions

    func fetchNextOffSet(_ offSet: Int, searchText: String) {
        functionsCalled.append(#function)
        lastOffSet = offSet
        lastSearchText = searchText

        repository?.searchItem(offSet: offSet, searchText: searchText)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.publisher?.send(.displayNextOffSetFailed(error))
                    }
                },
                receiveValue: { [weak self] result in
                    self?.publisher?.send(.displayNextOffSet(searchResult: result))
                }
            )
            .store(in: &searchTokens)
    }

    func fetchNextOffSet(_ offSet: Int, category: String) {
        functionsCalled.append(#function)
        lastOffSet = offSet
        lastCategory = category

        repository?.searchCategory(offSet: offSet, category: category)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.publisher?.send(.displayNextOffSetFailed(error))
                    }
                },
                receiveValue: { [weak self] result in
                    self?.publisher?.send(.displayNextOffSet(searchResult: result))
                }
            )
            .store(in: &searchTokens)
    }
}
