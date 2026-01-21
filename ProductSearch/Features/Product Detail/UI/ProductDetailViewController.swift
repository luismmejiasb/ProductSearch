import UIKit

// MARK: - ProductDetailViewController

@MainActor
final class ProductDetailViewController: UIViewController {
    // MARK: Properties

    var presenter: ProductDetailPresenterProtocol?

    private var imageLoadingTask: Task<Void, Never>?

    private var infoView: InfoView?

    // MARK: Views

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor.whiteColor
        scrollView.alwaysBounceHorizontal = false
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.white
        return imageView
    }()

    // MARK: Lifecycle

    init() {
        super.init(
            nibName: String(describing: ProductDetailViewController.self),
            bundle: Bundle(for: ProductDetailViewController.classForCoder())
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
        presenter?.displayProductDetail()
    }
}

// MARK: ProductDetailViewProtocol

extension ProductDetailViewController: ProductDetailViewProtocol {
    func displayProductDetail(_ product: Result) {
        loadImage(from: product.thumbnail)
        renderInfoView(for: product)
    }
}

// MARK: - Private

private extension ProductDetailViewController {
    func setUpUI() {
        title = "Detalle de tu producto"
        view.addSubview(scrollView)
        scrollView.addSubview(productImageView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),

            productImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            productImageView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            productImageView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            productImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            productImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
    }

    func renderInfoView(for product: Result) {
        infoView?.removeFromSuperview()

        let newInfoView = InfoView(product: product)
        newInfoView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(newInfoView)
        infoView = newInfoView

        let borderPadding = CGFloat(20)

        NSLayoutConstraint.activate([
            newInfoView.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: borderPadding),
            newInfoView.leftAnchor.constraint(equalTo: productImageView.leftAnchor),
            newInfoView.rightAnchor.constraint(equalTo: productImageView.rightAnchor),

            // Always pin bottom; UIScrollView needs it for content size.
            newInfoView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }

    func loadImage(from urlString: String?) {
        imageLoadingTask?.cancel()
        imageLoadingTask = Task { @MainActor in
            await productImageView.setImage(
                from: urlString ?? "",
                placeholder: UIImage(named: "productPlaceholderIcon")
            )
        }
    }
}
