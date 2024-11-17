//
//  PortfolioBaseViewController.swift
//  upstox
//
//  Created by Jayesh Agrawal on 17/11/24.
//

import UIKit

class PortfolioBaseViewController: UIViewController {

    let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Something Went Wrong!\n Please try again"
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = .purple
        return spinner
    }()

    func showLoadingSpinner() {
        spinner.center = view.center
        spinner.startAnimating()
        view.addSubview(spinner)
        view.bringSubviewToFront(spinner)
    }

    func hideLoadingSpinner() {
        spinner.stopAnimating()
        spinner.removeFromSuperview()
    }

    func showGenericError() {
        view.addSubview(errorLabel)

        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        view.bringSubviewToFront(errorLabel)
    }

    func removeError() {
        errorLabel.removeFromSuperview()
    }
}
