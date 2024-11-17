//
//  StockHoldingModel.swift
//  upstox
//
//  Created by Jayesh Agrawal on 16/11/24.
//

import Foundation

struct StocksDataResponse: Decodable {
    let data: UserHoldingsResponse
}

struct UserHoldingsResponse: Decodable {
    let userHolding: [StockHolding]
}

struct StockHolding: Decodable, Hashable {
    let symbol: String
    let quantity: Int
    let ltp: Double
    let averagePrice: Double
    let closePrice: Double

    enum CodingKeys: String, CodingKey {
        case symbol
        case quantity
        case ltp
        case averagePrice = "avgPrice"
        case closePrice = "close"
    }
}


