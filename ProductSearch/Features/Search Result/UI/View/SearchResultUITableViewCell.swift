import Foundation
import UIKit

@MainActor
class SearchResultUITableViewCell: UITableViewCell {
    // MARK: Static Properties

    static let reusableIdentifier = "searchResultTableViewCell"

    // MARK: Properties

    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var productPriceLabel: UILabel!
    @IBOutlet var productLocationLabel: UILabel!
    @IBOutlet var productImageView: UIImageView!

    // MARK: Overridden Functions

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: Functions

    func configureCell(with resultData: Result) {
        selectionStyle = .none

        productNameLabel.text = resultData.title ?? "Producto sin título"
        productPriceLabel.text = "\(resultData.price ?? 0) \(resultData.currencyID ?? "$") "

        if let city = resultData.sellerAddress?.city?.name,
           let state = resultData.sellerAddress?.state?.name {
            productLocationLabel.text = "\(city), \(state)"
        } else {
            productLocationLabel.text = "Sin ubicación"
        }

        productImageView.imageFromServerURL(resultData.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "productPlaceholderIcon"))
    }
}
