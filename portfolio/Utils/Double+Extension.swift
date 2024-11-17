//
//  Double+Extension.swift
//  upstox
//
//  Created by Jayesh Agrawal on 16/11/24.
//

import Foundation

extension Double {
    var toString: String {
        String(self)
    }
    
    var amountFormatWithRupeeSymbol: String {
        String(format: "\(self < 0 ? "-": "")\(Constants.rupee)%.2f", (abs(self)))
    }
}

extension Double {
    var twoDecimalPlaces: String {
        String(format: "%.2f", self)
    }
}
