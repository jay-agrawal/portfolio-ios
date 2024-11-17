//
//  UITableViewCell+Extension.swift
//  upstox
//
//  Created by Jayesh Agrawal on 16/11/24.
//

import UIKit

/// For diffable data source
enum Section {
    case first
}

extension UITableViewCell {
    @objc static var defaultIdentifier: String { return String(describing: self) }
}

extension UITableView {
    func registerClassWithDefaultIdentifier(cellClass: AnyClass) {
        register(cellClass, forCellReuseIdentifier: cellClass.defaultIdentifier)
    }

    func dequeueReusableCellWithDefaultIdentifier<T: UITableViewCell>() -> T {
        return dequeueReusableCell(withIdentifier: T.defaultIdentifier) as! T
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.defaultIdentifier, for: indexPath) as! T
    }
}
