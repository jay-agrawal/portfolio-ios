//
//  UIView+Extension.swift
//  upstox
//
//  Created by Jayesh Agrawal on 16/11/24.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        _ = views.map({ self.addSubview($0) })
    }
}
