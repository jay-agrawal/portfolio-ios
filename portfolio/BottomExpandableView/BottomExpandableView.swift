//
//  BottomExpandableView.swift
//  upstox
//
//  Created by Jayesh Agrawal on 17/11/24.
//

import UIKit

enum ExpansionState {
    case expanded
    case collapsed
}

final class BottomExpandableView: UIView {
    // MARK: - Properties
    // Constraints for managing height
    private var expandableHeightConstraint: NSLayoutConstraint!

    // Constants for collapsed and expanded states
    private let collapsedHeight: CGFloat = 70
    private let expandedHeight: CGFloat = 150
    private let pnlSnippet = AmountSnippet()
    private let currentValueSnippet = AmountSnippet()
    private let todaysPNLSnippet = AmountSnippet()
    private let totalInvestmentSnippet = AmountSnippet()

    private var expansionState: ExpansionState = .collapsed {
        didSet {
            updatedExpansionState()
        }
    }

    private let verticalExpandableStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let verticalExpandedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupExpandableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    private func setupExpandableView() {
        layer.borderColor = UIColor(hexString: "#D9D9D9").cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        backgroundColor = UIColor(hexString: "#F5F5F5")
        translatesAutoresizingMaskIntoConstraints = false

        verticalExpandedStackView.isHidden = true
        verticalExpandedStackView.addArrangedSubviews(
            currentValueSnippet,
            totalInvestmentSnippet,
            todaysPNLSnippet
        )
        verticalExpandableStackView.addArrangedSubviews(
            verticalExpandedStackView,
            pnlSnippet
        )
        self.addSubviews(verticalExpandableStackView)

        NSLayoutConstraint.activate([
            verticalExpandableStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            verticalExpandableStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            verticalExpandableStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            verticalExpandableStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])

        // Height constraint
        expandableHeightConstraint = heightAnchor.constraint(equalToConstant: collapsedHeight)
        expandableHeightConstraint.isActive = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleExpandableView))
        addGestureRecognizer(tapGesture)
    }

    private func updatedExpansionState() {
        verticalExpandedStackView.isHidden = expansionState == .collapsed
    }

    @objc private func toggleExpandableView() {
        // Toggle between expanded and collapsed states
        let isCollapsed = expandableHeightConstraint.constant == collapsedHeight
        expandableHeightConstraint.constant = isCollapsed ? expandedHeight : collapsedHeight

        // Animate the change
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.setExpansionState(to: isCollapsed)
            self?.layoutIfNeeded()
        }
    }

    func showPortfolioSummary(for portfolio: PortfolioSummary) {
        pnlSnippet.setData(text: "Profit & Loss", amount: portfolio.totalPnL, showChevron: true, isPnLSnippet: true)
        currentValueSnippet.setData(text: "Current Value",amount: portfolio.currentValue)
        totalInvestmentSnippet.setData(text: "Total Investment",amount: portfolio.totalInvestment)
        todaysPNLSnippet.setData(text: "Todays Profit & Loss", amount: portfolio.todaysPnL, showChevron: false, isPnLSnippet: true)
    }

    func setExpansionState(to isExpanded: Bool) {
        pnlSnippet.setChevronIconState(to: expansionState)
        expansionState = isExpanded ? .expanded : .collapsed
    }
}
