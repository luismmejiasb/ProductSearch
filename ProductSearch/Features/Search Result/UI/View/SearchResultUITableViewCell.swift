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
    static let reusableIdentifier = "searchResultTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        //setupUI()
    }

    func configureCell(with resultData: Result) {
        productNameLabel.text = resultData.title ?? "Producto sin título"
    }
    
    private func setupUI() {
        layer.cornerRadius = 5
        layer.borderWidth = 0.5
        layer.backgroundColor = UIColors.clearColor.cgColor
        layer.borderColor = UIColors.textColor.cgColor
    }
}
