import UIKit

// MARK: - ArtistDetailViewController

@MainActor
final class ArtistDetailViewController: UIViewController {
    // MARK: Properties

    var presenter: ArtistDetailPresenterProtocol?

    private var imageLoadingTask: Task<Void, Never>?

    private var infoView: ArtistInfoView?

    // MARK: Views

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor.backGroundColor
        scrollView.alwaysBounceHorizontal = false
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private lazy var artistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.white
        return imageView
    }()

    // MARK: Lifecycle

    init() {
        super.init(
            nibName: String(describing: ArtistDetailViewController.self),
            bundle: Bundle(for: ArtistDetailViewController.classForCoder())
        )
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("Missing presenter")
    }

    deinit {
        imageLoadingTask?.cancel()
    }

    // MARK: Overridden Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        presenter?.displayArtistDetail()
    }
}

// MARK: ArtistDetailViewProtocol

extension ArtistDetailViewController: ArtistDetailViewProtocol {
    func displayArtistDetail(_ artist: ArtistResult) {
        loadImage(from: artist.artworkUrl100 ?? artist.artworkUrl60)
        renderInfoView(for: artist)
    }
}

// MARK: - Private

private extension ArtistDetailViewController {
    func setUpUI() {
        title = "Artist Detail"
        view.addSubview(scrollView)
        scrollView.addSubview(artistImageView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),

            artistImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            artistImageView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            artistImageView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            artistImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            artistImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
    }

    func renderInfoView(for artist: ArtistResult) {
        infoView?.removeFromSuperview()

        let newInfoView = ArtistInfoView(artist: artist)
        newInfoView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(newInfoView)
        infoView = newInfoView

        let borderPadding = CGFloat(20)

        NSLayoutConstraint.activate([
            newInfoView.topAnchor.constraint(equalTo: artistImageView.bottomAnchor, constant: borderPadding),
            newInfoView.leftAnchor.constraint(equalTo: artistImageView.leftAnchor),
            newInfoView.rightAnchor.constraint(equalTo: artistImageView.rightAnchor),

            // Always pin bottom; UIScrollView needs it for content size.
            newInfoView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }

    func loadImage(from urlString: String?) {
        imageLoadingTask?.cancel()
        imageLoadingTask = Task { @MainActor in
            await artistImageView.setImage(
                from: urlString ?? "",
                placeholder: UIImage(named: "productPlaceholderIcon")
            )
        }
    }
}

