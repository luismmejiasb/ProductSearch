//
//  ProductDetailViewController.swift
//  ProductSearch
//
//  Created by Luis Mejias on 17-03-22.
//  Copyright (c) 2022 Falabella FIF. All rights reserved.

import UIKit

// MARK: - ProductDetailViewController
final class ProductDetailViewController: UIViewController {
    @IBOutlet weak var productNameLabel: UILabel!
    var presenter: ProductDetailPresenterProtocol?

    // MARK: Object lifecycle
    init() {
       super.init(nibName: String(describing: ProductDetailViewController.self), bundle: Bundle(for: ProductDetailViewController.classForCoder()))
    }

    required init?(coder aDecoder: NSCoder) {
       fatalError("Missing presenter")
    }
    
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
    }
}

// MARK: ProductDetailViewProtocol
extension ProductDetailViewController: ProductDetailViewProtocol {
    func displayProductDetail(_ product: Result) {
        productNameLabel.text = product.title
    }
}
