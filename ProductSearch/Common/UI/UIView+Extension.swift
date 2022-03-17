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
