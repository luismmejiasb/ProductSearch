//
//  ProductDetailRouter.swift
//  ProductSearch
//
//  Created by Luis Mejias on 17-03-22.
//  Copyright (c) 2022 Luis Mejías. All rights reserved.

import UIKit

// MARK: - ProductDetailRouter
final class ProductDetailRouter: ProductDetailRouterProtocol {
    weak var view: UIViewController?
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
        view?.present(alert, animated: true, completion: nil)
    }
}
