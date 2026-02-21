import UIKit

// MARK: - HomeViewController

@MainActor
final class HomeViewController: HomeViewControllerProtocol {
    // MARK: Properties

    var presenter: HomePresenterProtocol?

    // MARK: Private Views

    private lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.text = "Browse by genre"
        label.font = .systemFont(ofSize: 11)
        label.textColor = UIColor.whiteColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var genreScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var genreStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: Computed Properties

    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 70))
        bar.backgroundColor = UIColor.themeRegularColor
        bar.delegate = self
        bar.setValue("Cancelar", forKey: "cancelButtonText")
        bar.placeholder = "Search Artist on iTunes"
        return bar
    }()

    // MARK: Lifecycle

    init() {
        super.init(nibName: String(describing: HomeViewController.self), bundle: Bundle(for: HomeViewController.classForCoder()))
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("Missing presenter")
    }

    // MARK: Overridden Functions

    override public func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        presenter?.viewDidLoad()
    }

    // MARK: Actions

    @objc func genreButtonTapped(_ sender: UIButton) {
        guard let category = HomeCategorySearch(rawValue: sender.tag) else { return }
        UILoadingIndicator.startLoadingIndicatorIn(view, position: .center)
        presenter?.searchByCategory(category)
    }
}

// MARK: Private UI functions

private extension HomeViewController {
    func setUpUI() {
        view.backgroundColor = UIColor.backGroundColor
        navigationItem.titleView = searchBar
        buildGenreBar()
    }

    func buildGenreBar() {
        view.addSubview(genreLabel)
        view.addSubview(genreScrollView)
        genreScrollView.addSubview(genreStackView)

        NSLayoutConstraint.activate([
            genreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            genreLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),

            genreScrollView.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 8),
            genreScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            genreScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            genreScrollView.heightAnchor.constraint(equalToConstant: 42),

            genreStackView.topAnchor.constraint(equalTo: genreScrollView.topAnchor, constant: 4),
            genreStackView.bottomAnchor.constraint(equalTo: genreScrollView.bottomAnchor, constant: -4),
            genreStackView.leadingAnchor.constraint(equalTo: genreScrollView.leadingAnchor, constant: 16),
            genreStackView.trailingAnchor.constraint(equalTo: genreScrollView.trailingAnchor, constant: -16),
            genreStackView.heightAnchor.constraint(equalToConstant: 34),
        ])

        let genres: [HomeCategorySearch] = [
            .reggaeton, .salsa, .merengue, .bachata, .cumbia,
            .pop, .rock, .jazz, .electronica, .hipHop
        ]
        genres.forEach { genreStackView.addArrangedSubview(makeGenreButton(for: $0)) }
    }

    func makeGenreButton(for genre: HomeCategorySearch) -> UIButton {
        let button = UIButton(type: .system)
        button.tag = genre.rawValue
        button.setTitle(genre.uiTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.secundaryActionColor
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.layer.cornerRadius = 14
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 14, bottom: 6, right: 14)
        button.addTarget(self, action: #selector(genreButtonTapped(_:)), for: .touchUpInside)
        return button
    }
}

// MARK: HomeViewProtocol

extension HomeViewController {
    func endLoadingIndicator() {
        UILoadingIndicator.endLoadingIndicator(view)
    }
}
