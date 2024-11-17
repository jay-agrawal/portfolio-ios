//
//  StockHoldingViewModel.swift
//  upstox
//
//  Created by Jayesh Agrawal on 16/11/24.
//

import Foundation
import Network

protocol StockHoldingProtocol {
    var portfolioSummary: PortfolioSummary { get }
    var state: StockHoldingViewModelState { get }
    func fetchData()
}

final class StockHoldingViewModel: StockHoldingProtocol {

    // MARK: - Properties
    var updatedState: (() -> Void)?
    private var stocksResponse: StocksDataResponse?
    var state: StockHoldingViewModelState {
        didSet {
            updatedState?()
        }
    }
    
    private var totalPnL: Double? {
        guard let currentValue, let totalInvestment else { return nil }
        return currentValue - totalInvestment
    }
    
    private var currentValue: Double? {
        stocksResponse?.data.userHolding.reduce(Double.zero) { partialResult, stock in
            partialResult + (stock.ltp * Double(stock.quantity))
        }
    }
    
    private var totalInvestment: Double? {
        stocksResponse?.data.userHolding.reduce(Double.zero) { partialResult, stock in
            partialResult + (stock.averagePrice * Double(stock.quantity))
        }
    }
    
    private var todaysPnL: Double? {
        stocksResponse?.data.userHolding.reduce(Double.zero) { partialResult, stock in
            partialResult + ((stock.closePrice - stock.ltp) * Double(stock.quantity))
        }
    }

    var portfolioSummary: PortfolioSummary {
        PortfolioSummary(
            todaysPnL: todaysPnL,
            currentValue: currentValue,
            totalPnL: totalPnL,
            totalInvestment: totalInvestment
        )
    }

    // MARK: - Init
    init() {
        self.state = .loading
        
    }
    
    // MARK: - Methods
    func fetchData() {
        state = .loading
        let request = Request<StocksDataResponse>(method: .get, path: "")
        guard let url = (URL(string: EndPoints.holdings.rawValue)) else {
            return
        }
        Task {
            do  {
                let result = try await APIManager.shared.execute(request, url: url)
                switch result {
                    case .success(let userHoldings):
                        stocksResponse = userHoldings
                        self.state = .loaded(userHoldings)
                    case .failure:
                        stocksResponse = nil
                        self.state = .error
                }
            } catch {
                self.state = .error
            }
        }
    }
}
