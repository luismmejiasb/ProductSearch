import UIKit

// MARK: - SearchResultViewController

final class SearchResultViewController: UIViewController {
    // MARK: Properties

    @IBOutlet var searchResultTableView: UITableView! {
        didSet {
            searchResultTableView.register(SearchResultUITableViewCell.nib, forCellReuseIdentifier: SearchResultUITableViewCell.reusableIdentifier)
            searchResultTableView.delegate = self
            searchResultTableView.dataSource = self
        }
    }

    @IBOutlet var resultCountLabel: UILabel!
    var presenter: SearchResultPresenterProtocol?

    private lazy var filterButton: UIBarButtonItem = {
        let filterButton = UIBarButtonItem(image: #imageLiteral(resourceName: "filterIcon"), style: .plain, target: self, action: #selector(filterSearchResult))
        filterButton.isEnabled = (presenter?.searchResult.paging?.total ?? 0) != 0
        return filterButton
    }()

    // MARK: Lifecycle

    // MARK: Object lifecycle

    init() {
        super.init(nibName: String(describing: SearchResultViewController.self), bundle: Bundle(for: SearchResultViewController.classForCoder()))
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("Missing presenter")
    }

    // MARK: Overridden Functions

    override public func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setUpUI()
    }

    // MARK: Functions

    @IBAction func filterSearchResult(_: Any) {
        presenter?.presentFilterTypeActionSheet()
    }
}

// MARK: Private functions

private extension SearchResultViewController {
    func setUpUI() {
        if presenter?.searchType == .text {
            title = "Resultados para \(presenter?.searchResult.query ?? "")"
        } else if presenter?.searchType == .category {
            guard let category = presenter?.searchCategory else {
                return
            }

            title = "Resultados para \(category.uiTitle)"
        }

        if let paging = presenter?.searchResult.paging,
           let totalCount = paging.total {
            resultCountLabel.text = "\(totalCount) \((totalCount != 1) ? "resultados" : "resultado")"
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
            resultCountLabel.text = "Filtra los resultados de tu búsqueda"
        }

        navigationItem.setRightBarButtonItems([filterButton], animated: false)
    }
}

// MARK: SearchResultViewProtocol

extension SearchResultViewController: SearchResultViewProtocol {
    func displaySearchResult() {
        searchResultTableView.reloadData()
    }

    func displayNextOffSetResult(_ nextOffSetResult: SearchResult, searchType _: SearchType, searchCategory _: HomeCategorySearch?) {
        guard let searchResults = presenter?.searchResult.results,
              let nextOffSetResults = nextOffSetResult.results else {
            return
        }
        presenter?.searchResult.results = searchResults + nextOffSetResults
        searchResultTableView.reloadData()
        UILoadingIndicator.endLoadingIndicator(view)
    }

    func endLoadingIndicator() {
        UILoadingIndicator.endLoadingIndicator(view)
    }
}
