//
//  UIView+Extension.swift
//  ProductSearch
//
//  Created by Luis Mejias on 17-03-22.
//

import UIKit

extension UIView {
    static var nib: UINib {
        return UINib(nibName: NSStringFromClass(self).components(separatedBy: ".").last!, bundle: Bundle.main)
    }
}

extension UINavigationController {
    func setUpNavigationController() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.themeRegularColor
        navigationBar.standardAppearance = appearance;
        navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
    }
}
