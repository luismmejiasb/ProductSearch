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
    @IBOutlet weak var cellBackgroundView: UIView!
    static let reusableIdentifier = "searchResultTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(with resultData: Result) {
        setupUI()
        productNameLabel.text = resultData.title ?? "Producto sin título"
        productPriceLabel.text = "$ \(resultData.price ?? 0)"
    }
    
    private func setupUI() {
        cellBackgroundView.layer.cornerRadius = 5
    }
}
