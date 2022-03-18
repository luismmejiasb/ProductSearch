//
//  UILoadingIndicator.swift
//  ProductSearch
//
//  Created by Luis Mejias on 17-03-22.
//

import Foundation
import UIKit

class UILoadingIndicator {
    enum UILoadingIndicatorPosition {
        case top
        case center
        case bottom
    }

    static func startLoadingIndicatorIn(_ view: UIView, position: UILoadingIndicatorPosition) {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = .black
        spinner.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.814472628)
        
        var yPosition: CGFloat = 0.0
        switch position {
        case .top:
            yPosition = 110
        case .center:
            yPosition = view.frame.size.height / 2 - 10
        case .bottom:
            yPosition = view.frame.size.height - 50
        }

        spinner.frame = CGRect(x: (view.frame.size.width / 2) - 10, y: yPosition, width: 20.0, height: 20.0)
        spinner.startAnimating()

        view.addSubview(spinner)
    }
    
    static func endLoadingIndicator(_ view: UIView) {
        for subview in view.subviews where subview is UIActivityIndicatorView {
            subview.removeFromSuperview()
        }
    }
}
