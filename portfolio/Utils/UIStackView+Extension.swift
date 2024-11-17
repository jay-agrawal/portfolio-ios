//
//  UIStackView+Extension.swift
//  upstox
//
//  Created by Jayesh Agrawal on 16/11/24.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ subviews: UIView...) {
        for subview in subviews {
            addArrangedSubview(subview)
        }
    }
}
