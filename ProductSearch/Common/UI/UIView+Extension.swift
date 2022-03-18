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
//        navigationBar.barTintColor = UIColors.normalTintColor
//        navigationBar.isTranslucent = true
//        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColors.textColor]
//        navigationBar.backItem?.titleView?.tintColor = UIColors.darkTintColor
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColors.normalTintColor
        navigationBar.standardAppearance = appearance;
        navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
    }
}
