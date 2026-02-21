import UIKit

// MARK: - SearchResultViewController

@MainActor
final class SearchResultViewController: UIViewController {
    // MARK: Properties

    @IBOutlet var searchResultTableView: UITableView! {
        didSet {
            searchResultTableView.register(
                SearchResultUITableViewCell.nib,
                forCellReuseIdentifier: SearchResultUITableViewCell.reusableIdentifier
            )
            searchResultTableView.backgroundColor = UIColor.clear
            searchResultTableView.separatorColor = UIColor.themeRegularColor
            searchResultTableView.delegate = self
            searchResultTableView.dataSource = self
        }
    }

    @IBOutlet var resultCountLabel: UILabel!
    var presenter: SearchResultPresenterProtocol?

    private lazy var filterButton: UIBarButtonItem = {
        let filterButton = UIBarButtonItem(image: #imageLiteral(resourceName: "filterIcon"), style: .plain, target: self, action: #selector(filterSearchResult))
        filterButton.isEnabled = (presenter?.getSearchResult()?.resultCount ?? 0) != 0
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
        view.backgroundColor = UIColor.backGroundColor
        
        guard let presenter else {
            return
        }
        let searchType = presenter.getSearchType()

        switch searchType {
        case .text:
            title = "Results for \(presenter.getSearchResult()?.searchText ?? "")"
        case .category:
            title = "Results for \(presenter.getSearchCategory().uiTitle)"
        }

        if let resultCount = presenter.getSearchResult()?.resultCount {
            resultCountLabel.text = "\(resultCount) \((resultCount != 1) ? "results" : "result")"
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
            resultCountLabel.text = "Filter your search results"
        }

        navigationItem.setRightBarButtonItems([filterButton], animated: false)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.themeAccentColor]
        
    }
}

// MARK: SearchResultViewProtocol

extension SearchResultViewController: SearchResultViewProtocol {
    func displaySearchResult() {
        searchResultTableView.reloadData()
    }

    func displayNextPageResult(
        _ nextPageResult: ArtistSearchResult,
        searchType _: SearchType,
        searchCategory _: HomeCategorySearch?
    ) {
        guard
            let searchResults = presenter?.getSearchResult()?.results,
            let nextPageResults = nextPageResult.results else {
            return
        }
        presenter?.setSearchResult(results: searchResults + nextPageResults)
        searchResultTableView.reloadData()
        UILoadingIndicator.endLoadingIndicator(view)
    }

    func endLoadingIndicator() {
        UILoadingIndicator.endLoadingIndicator(view)
    }
}
