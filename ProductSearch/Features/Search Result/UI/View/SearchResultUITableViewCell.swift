//
//  SearchResultUITableViewCell.swift
//  ProductSearch
//
//  Created by Luis Mejias on 17-03-22.
//

import Foundation
import UIKit

class SearchResultUITableViewCell: UITableViewCell {
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productLocationLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    static let reusableIdentifier = "searchResultTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(with resultData: Result) {
        self.selectionStyle = .none

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
