import Combine
import UIKit

// MARK: - SearchResultFactoryProtocol

protocol SearchResultFactoryProtocol: AnyObject {
    static func initialize(homeSearchResult: SearchResult, searchType: SearchType, searchCategory: HomeCategorySearch?) -> SearchResultViewController
}

// MARK: - SearchResultInteractorProtocol

protocol SearchResultInteractorProtocol: AnyObject {
    var repository: SearchResultRepositoryProtocol? { get set }
    var publisher: PassthroughSubject<SearchResultPublisherResult, Error>? { get set }

    func fetchNextOffSet(_ offSet: Int, searchText: String)
    func fetchNextOffSet(_ offSet: Int, category: String)
}

// MARK: - SearchResultViewProtocol

protocol SearchResultViewProtocol: AnyObject {
    var presenter: SearchResultPresenterProtocol? { get set }

    func displaySearchResult()
    func displayNextOffSetResult(_ nextOffSetResult: SearchResult, searchType: SearchType, searchCategory: HomeCategorySearch?)
    func endLoadingIndicator()
}

// MARK: - SearchResultRouterProtocol

protocol SearchResultRouterProtocol: AnyObject {
    var view: UIViewController? { get set }
    var delegate: SearchResultRouterDelegate? { get set }

    func presentFilterTypeActionSheet()
    func presentProductDetail(_ result: Result)
    func displayAlert(title: String, message: String)
}

// MARK: - SearchResultRouterDelegate

protocol SearchResultRouterDelegate: AnyObject {
    func didSelectFilter(_ filter: FilterType)
}

// MARK: - SearchResultPresenterProtocol

protocol SearchResultPresenterProtocol: AnyObject {
    var interactor: SearchResultInteractorProtocol? { get set }
    var router: SearchResultRouterProtocol? { get set }
    var view: SearchResultViewProtocol? { get set }
    var searchResult: SearchResult { get set }
    var searchType: SearchType { get set }
    var searchCategory: HomeCategorySearch? { get set }

    func viewDidLoad()
    func presentFilterTypeActionSheet()
    func fetchNextOffSet()
    func presentProductDetail(_ result: Result)
}

// MARK: - SearchResultPublisherResult

enum SearchResultPublisherResult {
    case displayNextOffSet(searchResult: SearchResult)
    case displayNextOffSetFailed(Error)
}

// MARK: - FilterType

enum FilterType {
    case lowestPrice
    case highestPrice
}

// MARK: - SearchType

enum SearchType {
    case text
    case category
}
