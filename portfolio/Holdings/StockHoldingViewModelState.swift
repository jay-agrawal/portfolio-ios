//
//  StockHoldingViewModelState.swift
//  upstox
//
//  Created by Jayesh Agrawal on 17/11/24.
//

enum StockHoldingViewModelState {
    case loading
    case loaded(StocksDataResponse)
    case error

    var userHolding: StocksDataResponse? {
        switch self {
            case .loaded(let userHolding):
                return userHolding
            case .loading, .error:
                return nil
        }
    }
}
