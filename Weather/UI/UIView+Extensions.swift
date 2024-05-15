import UIKit

extension UIView {

    static func spacer(height: CGFloat) -> UIView {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: height).isActive = true

        return view
    }
}
