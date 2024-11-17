//
//  String+Extension.swift
//  upstox
//
//  Created by Jayesh Agrawal on 17/11/24.
//

import UIKit

extension String {
    func colorSubstring(substring: String, color: UIColor) -> NSAttributedString {
        // Create an NSMutableAttributedString from the full text
        let attributedString = NSMutableAttributedString(string: self)
        // Find all ranges of the substring within the full text
        let range = (self as NSString).range(of: substring)
        if range.location != NSNotFound {
            // Apply the color attribute to each found range
            attributedString.addAttribute(.foregroundColor, value: color, range: range)
        }
        return attributedString
    }
}
