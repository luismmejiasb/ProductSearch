import Foundation
import UIKit

class UILoadingIndicator {
    // MARK: Nested Types

    enum UILoadingIndicatorPosition {
        case top
        case center
        case bottom
    }

    // MARK: Static Functions

    @MainActor
    static func startLoadingIndicatorIn(_ view: UIView, position: UILoadingIndicatorPosition) {
        view.isUserInteractionEnabled = false

        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = UIColor.primaryActionColor
        spinner.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)

        var yPosition: CGFloat = 0.0
        switch position {
        case .top:
            yPosition = 140
        case .center:
            yPosition = view.frame.size.height / 2 - 10
        case .bottom:
            yPosition = view.frame.size.height - 50
        }

        spinner.frame = CGRect(x: (view.frame.size.width / 2) - 10, y: yPosition, width: 20.0, height: 20.0)
        spinner.startAnimating()

        view.addSubview(spinner)
    }

    @MainActor
    static func endLoadingIndicator(_ view: UIView) {
        view.isUserInteractionEnabled = true

        for subview in view.subviews where subview is UIActivityIndicatorView {
            subview.removeFromSuperview()
        }
    }
}
