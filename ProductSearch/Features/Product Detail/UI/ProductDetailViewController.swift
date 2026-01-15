import UIKit

// MARK: - ProductDetailViewController

final class ProductDetailViewController: UIViewController {
    // MARK: Properties

    var presenter: ProductDetailPresenterProtocol?

    var infoView = InfoView()

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
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        img.backgroundColor = UIColor.white
        return img
    }()

    // MARK: Lifecycle

    // MARK: Object lifecycle

    init() {
        super.init(nibName: String(describing: ProductDetailViewController.self), bundle: Bundle(for: ProductDetailViewController.classForCoder()))
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("Missing presenter")
    }

    // MARK: Overridden Functions

    override public func viewDidLoad() {
        super.viewDidLoad()
        presenter?.displayProductDetail()
        setUpUI()
    }
}

// MARK: Private functions

private extension ProductDetailViewController {
    func setUpUI() {
        title = "Detalle de tu producto"
        view.addSubview(scrollView)
        scrollView.addSubview(productImageView)
        setupLayout()
    }

    // MARK: Layout

    func setupLayout() {
        let borderPadding = CGFloat(20)
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

            infoView.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: borderPadding),
            infoView.leftAnchor.constraint(equalTo: productImageView.leftAnchor),
            infoView.rightAnchor.constraint(equalTo: productImageView.rightAnchor),
        ])

        if presenter?.product.attributes?.isEmpty != true {
            NSLayoutConstraint.activate([
                infoView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            ])
        }
    }
}

// MARK: ProductDetailViewProtocol

extension ProductDetailViewController: ProductDetailViewProtocol {
    func displayProductDetail(_ product: Result) {
        if let productImageURL = product.thumbnail {
            productImageView.imageFromServerURL(productImageURL, placeHolder: #imageLiteral(resourceName: "productPlaceholderIcon"))
        }

        infoView = InfoView(product: product)
        infoView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(infoView)
    }
}
