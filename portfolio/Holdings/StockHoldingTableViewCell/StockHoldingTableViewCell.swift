//
//  StockHoldingTableViewCell.swift
//  upstox
//
//  Created by Jayesh Agrawal on 16/11/24.
//

import UIKit

final class StockHoldingTableViewCell: UITableViewCell {
    //MARK: - Properties
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()

    private let ltpLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let pnlLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Methods
    private func setupSubviews() {
        contentView.addSubviews(
            topStackView,
            bottomStackView
        )
        topStackView.addArrangedSubviews(symbolLabel, ltpLabel)
        bottomStackView.addArrangedSubviews(quantityLabel, pnlLabel)

        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            topStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            topStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),

            bottomStackView.topAnchor.constraint(equalTo: topStackView.layoutMarginsGuide.bottomAnchor, constant: 16),
            bottomStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            bottomStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            bottomStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }

    func setData(with data: StockHolding) {
        setQuantityText(with: data)
        setLTPText(with: data)
        symbolLabel.text = data.symbol
        setPNLText(with: data)
    }

    private func setQuantityText(with data: StockHolding) {
        let fullText = "NET QTY: " + data.quantity.toString
        // Create a mutable attributed string from the full text
        let attributedString = NSMutableAttributedString(string: fullText)

        // Apply the first set of attributes to a substring
        if let firstRange = fullText.range(of: "NET QTY: ") {
            // Define attributes for the first part of the text
            let firstAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.gray,
                .font: UIFont.systemFont(ofSize: 10, weight: .regular)
            ]
            attributedString.addAttributes(firstAttributes, range: NSRange(firstRange, in: fullText))
        }

        // Apply the second set of attributes to another substring
        if let secondRange = fullText.range(of: data.quantity.toString) {
            // Define attributes for the second part of the text
            let secondAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 12, weight: .semibold)
            ]
            attributedString.addAttributes(secondAttributes, range: NSRange(secondRange, in: fullText))
        }

        quantityLabel.attributedText = attributedString
    }

    private func setLTPText(with data: StockHolding) {
        let fullText = "LTP: " + Constants.rupee + data.ltp.toString
        // Create a mutable attributed string from the full text
        let attributedString = NSMutableAttributedString(string: fullText)

        // Apply the first set of attributes to a substring
        if let firstRange = fullText.range(of: "LTP: ") {
            // Define attributes for the first part of the text
            let firstAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.gray,
                .font: UIFont.systemFont(ofSize: 10, weight: .regular)
            ]
            attributedString.addAttributes(firstAttributes, range: NSRange(firstRange, in: fullText))
        }

        // Apply the second set of attributes to another substring
        if let secondRange = fullText.range(of: Constants.rupee + data.ltp.toString) {
            // Define attributes for the second part of the text
            let secondAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 12, weight: .semibold)
            ]
            attributedString.addAttributes(secondAttributes, range: NSRange(secondRange, in: fullText))
        }

        ltpLabel.attributedText = attributedString
    }

    private func setPNLText(with data: StockHolding) {
        let pnl = (data.ltp - data.averagePrice) * Double(data.quantity)
        let pnlSubstring = pnl.amountFormatWithRupeeSymbol
        let pnlFullText = "P&L: " + pnlSubstring
        pnlLabel.attributedText = pnlFullText.colorSubstring(substring: pnlSubstring, color: pnl < 0 ? .red : .systemGreen)
    }

    override func prepareForReuse() {
        symbolLabel.text = nil
        pnlLabel.text = nil
        ltpLabel.text = nil
        quantityLabel.text = nil
        super.prepareForReuse()
    }
}



