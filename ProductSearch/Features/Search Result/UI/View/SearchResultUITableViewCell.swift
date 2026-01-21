import UIKit

@MainActor
final class SearchResultUITableViewCell: UITableViewCell {

    // MARK: Static Properties

    static let reusableIdentifier = "searchResultTableViewCell"

    // MARK: Outlets

    @IBOutlet private var productNameLabel: UILabel!
    @IBOutlet private var productPriceLabel: UILabel!
    @IBOutlet private var productLocationLabel: UILabel!
    @IBOutlet private var productImageView: UIImageView!

    // MARK: Properties

    private var imageLoadingTask: Task<Void, Never>?

    // MARK: Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()

        imageLoadingTask?.cancel()
        imageLoadingTask = nil

        productImageView.image = nil
    }

    // MARK: Configuration

    func configureCell(with resultData: Result) {
        selectionStyle = .none

        productNameLabel.text = resultData.title ?? "Producto sin título"
        productPriceLabel.text = "\(resultData.price ?? 0) \(resultData.currencyID ?? "$")"

        configureLocation(with: resultData)
        loadImage(from: resultData.thumbnail)
    }
}

private extension SearchResultUITableViewCell {
    func configureLocation(with resultData: Result) {
        guard
            let city = resultData.sellerAddress?.city?.name,
            let state = resultData.sellerAddress?.state?.name
        else {
            productLocationLabel.text = "Sin ubicación"
            return
        }

        productLocationLabel.text = "\(city), \(state)"
    }

    func loadImage(from urlString: String?) {
        imageLoadingTask = Task { @MainActor in
            await productImageView.setImage(
                from: urlString ?? "",
                placeholder: UIImage(named: "productPlaceholderIcon")
            )
        }
    }
}
