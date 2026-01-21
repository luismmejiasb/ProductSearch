import Foundation
import UIKit

@MainActor
class InfoView: UIView {
    // MARK: Properties

    var product: Result?

    // MARK: Views

    private lazy var conditionLabel: UILabel = {
        let conditionLabel = UILabel()
        conditionLabel.translatesAutoresizingMaskIntoConstraints = false
        conditionLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        conditionLabel.textColor = .gray
        conditionLabel.text = "Estado: \((product?.condition ?? "NA").capitalized) - \(product?.availableQuantity ?? 0) en Stock"
        return conditionLabel
    }()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = .darkGray
        titleLabel.numberOfLines = 0
        titleLabel.text = product?.title ?? "Producto sin título"
        return titleLabel
    }()

    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        priceLabel.textColor = .black

        priceLabel.text = "\(product?.price ?? 0) \(product?.currencyID ?? "$") "
        return priceLabel
    }()

    private lazy var locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        locationLabel.textColor = .darkGray

        if let city = product?.sellerAddress?.city?.name,
           let state = product?.sellerAddress?.state?.name {
            locationLabel.text = "Ubicación: \(city), \(state)"
        } else {
            locationLabel.text = "Sin ubicación"
        }

        return locationLabel
    }()

    private lazy var soldQuantityLabel: UILabel = {
        let soldQuantityLabel = UILabel()
        soldQuantityLabel.translatesAutoresizingMaskIntoConstraints = false
        soldQuantityLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        soldQuantityLabel.textColor = .darkGray

        if let soldQuantity = product?.soldQuantity {
            soldQuantityLabel.text = "Vendido(s): \(soldQuantity)"
        } else {
            soldQuantityLabel.text = "Sin ubicación"
        }

        return soldQuantityLabel
    }()

    private let buyButton: UIButton = {
        let buyButton = UIButton(type: .system)
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        buyButton.tintColor = UIColor.white
        buyButton.backgroundColor = UIColor.primaryActionColor
        buyButton.setTitle("Comprar", for: .normal)
        buyButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        buyButton.layer.cornerRadius = 5
        return buyButton
    }()

    // MARK: Lifecycle

    // MARK: Initializers

    required init(product: Result?) {
        self.product = product
        super.init(frame: CGRect.zero)

        addSubview(conditionLabel)
        addSubview(titleLabel)
        addSubview(priceLabel)
        addSubview(locationLabel)
        addSubview(soldQuantityLabel)
        addSubview(buyButton)

        setupLayout()
    }

    init() {
        super.init(frame: CGRect.zero)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Functions

    // MARK: Layout

    private func setupLayout() {
        let borderPadding = CGFloat(20)

        NSLayoutConstraint.activate([
            conditionLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: borderPadding),
            conditionLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: borderPadding),
            conditionLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -borderPadding),

            titleLabel.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor, constant: 15),
            titleLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: borderPadding),
            titleLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -borderPadding),

            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            priceLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: borderPadding),
            priceLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -borderPadding),

            locationLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 15),
            locationLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: borderPadding),
            locationLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -borderPadding),

            soldQuantityLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 15),
            soldQuantityLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: borderPadding),
            soldQuantityLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -borderPadding),

            buyButton.topAnchor.constraint(equalTo: soldQuantityLabel.bottomAnchor, constant: 25),
            buyButton.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: borderPadding),
            buyButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -borderPadding),
            buyButton.heightAnchor.constraint(equalToConstant: 50),
            buyButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -borderPadding),
        ])
    }
}
