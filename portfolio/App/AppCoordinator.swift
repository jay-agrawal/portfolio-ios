//
//  AppCoordinator.swift
//  upstox
//
//  Created by Jayesh Agrawal on 16/11/24.
//

import UIKit

enum ActionType {
    case portfolio
}

protocol ActionDelegate: AnyObject {
    func processAction(_ action: ActionType)
}

final class AppCoordinator: ActionDelegate {

    var navController: UINavigationController

    init(navController: UINavigationController) {
        self.navController = navController
        navController.navigationBar.frame = .zero
    }

    func processAction(_ action: ActionType) {
        switch action {
            case .portfolio:
                navigateToPortfolioController()
        }
    }

    private func navigateToPortfolioController() {
        let stockHoldingViewController = StockHoldingViewController()
        navController.pushViewController(stockHoldingViewController, animated: true)
    }
}
