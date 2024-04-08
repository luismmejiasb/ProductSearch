//
//  ProductDetailPresenter.swift
//  ProductSearch
//
//  Created by Luis Mejias on 17-03-22.
//  Copyright (c) 2022 Luis Mejías. All rights reserved.

import UIKit

// MARK: - ProductDetailPresenter
final class ProductDetailPresenter: ProductDetailPresenterProtocol {
    internal var interactor: ProductDetailInteractorProtocol?
    internal var router: ProductDetailRouterProtocol?
    internal weak var view: ProductDetailViewProtocol?
    var product: Result

    // MARK: - Inits
    init(interactor: ProductDetailInteractorProtocol?, router: ProductDetailRouterProtocol?, product: Result) {
        self.interactor = interactor
        self.router = router
        self.product = product
    }

    func displayProductDetail() {
        view?.displayProductDetail(product)
    }
}
