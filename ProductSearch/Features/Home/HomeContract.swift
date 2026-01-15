import Combine
import UIKit

// MARK: - HomeFactoryProtocol

protocol HomeFactoryProtocol: AnyObject {
    static func initialize() -> HomeViewController
}

// MARK: - HomeInteractorProtocol

protocol HomeInteractorProtocol: AnyObject {
    var repository: HomeRepositoryProtocol? { get set }
    var publisher: PassthroughSubject<HomePublisherResult, Error>? { get set }

    func serachItem(searchText: String)
    func searchByCategory(_ category: HomeCategorySearch)
}

// MARK: - HomeViewProtocol

protocol HomeViewProtocol: AnyObject {
    var presenter: HomePresenterProtocol? { get set }

    func displaySearchResult(_ searchResults: SearchResult, searchType: SearchType, searchCategory: HomeCategorySearch?)
    func endLoadingIndicator()
}

// MARK: - HomeRouterProtocol

protocol HomeRouterProtocol: AnyObject {
    var view: HomeViewControllerProtocol? { get set }

    func presentSearchResult(_ searchResult: SearchResult, searchType: SearchType, searchCategory: HomeCategorySearch?)
    func displayAlert(title: String, message: String)
}

// MARK: - HomePresenterProtocol

protocol HomePresenterProtocol: AnyObject {
    var interactor: HomeInteractorProtocol? { get set }
    var router: HomeRouterProtocol? { get set }
    var view: HomeViewControllerProtocol? { get set }

    func viewDidLoad()
    func searchItem(searchText: String)
    func searchByCategory(_ category: HomeCategorySearch)
    func presentSearchResult(_ searchResult: SearchResult, searchType: SearchType, searchCategory: HomeCategorySearch?)
}

// MARK: - HomePublisherResult

enum HomePublisherResult {
    case itemsSearchedWithSuccess(searchResult: SearchResult)
    case itemsSearchedWithFailure(Error)
    case categorySearchedWithSuccess(searchResult: SearchResult, searchedCategory: HomeCategorySearch)
    case categorySearchedWithFailure(Error)
}

typealias HomeViewControllerProtocol = HomeViewProtocol & UIViewController
