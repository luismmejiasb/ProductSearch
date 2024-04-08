//
//  ProductDetailContract.swift
//  ProductSearch
//
//  Created by Luis Mejias on 17-03-22.
//  Copyright (c) 2022 Luis Mejías. All rights reserved.

import UIKit

// MARK: - Factory

protocol ProductDetailFactoryProtocol: AnyObject {
    static func initialize(product: Result) -> ProductDetailViewController
}

// MARK: - Interactor

protocol ProductDetailInteractorProtocol: AnyObject {
    var repository: ProductDetailRepositoryProtocol? { get set }
}

// MARK: - View

protocol ProductDetailViewProtocol: AnyObject {
    var presenter: ProductDetailPresenterProtocol? { get set }

    func displayProductDetail(_ product: Result)
}

// MARK: - Router

protocol ProductDetailRouterProtocol: AnyObject {
    var view: UIViewController? { get set }

    func displayAlert(title: String, message: String)
}

// MARK: - Presenter

protocol ProductDetailPresenterProtocol: AnyObject {
    var interactor: ProductDetailInteractorProtocol? { get set }
    var router: ProductDetailRouterProtocol? { get set }
    var view: ProductDetailViewProtocol? { get set }
    var product: Result { get set }

    func displayProductDetail()
}
