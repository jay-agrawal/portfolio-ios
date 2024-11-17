//
//  AmountSnippet.swift
//  upstox
//
//  Created by Jayesh Agrawal on 17/11/24.
//

import UIKit

class AmountSnippet: UIView {

    // MARK: - Properties
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()

    private let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()

    private let chevronImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "chevron")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let chevronView = UIView()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    private func setView() {
        chevronImage.isHidden = true
        chevronView.addSubviews(textLabel, chevronImage)
        horizontalStackView.addArrangedSubviews(chevronView, amountLabel)
        addSubviews(horizontalStackView)

        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            textLabel.leadingAnchor.constraint(equalTo: chevronView.leadingAnchor),
            textLabel.topAnchor.constraint(equalTo: chevronView.topAnchor),
            textLabel.bottomAnchor.constraint(equalTo: chevronView.bottomAnchor),

            chevronImage.leadingAnchor.constraint(equalTo: textLabel.trailingAnchor, constant: 8),
            chevronImage.trailingAnchor.constraint(equalTo: chevronView.trailingAnchor),

            chevronImage.widthAnchor.constraint(equalToConstant: 32),
            chevronImage.heightAnchor.constraint(equalToConstant: 32),
            chevronImage.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor)
        ])
    }

    func setData(
        text: String,
        amount: Double?,
        showChevron: Bool = false,
        isPnLSnippet: Bool = false
    ) {
        textLabel.text = text
        amountLabel.text = amount?.amountFormatWithRupeeSymbol
        chevronImage.isHidden = !showChevron
        if isPnLSnippet, let amount {
            switch amount {
                case let x where x < 0:
                    amountLabel.textColor = .red
                case let x where x > 0:
                    amountLabel.textColor = .systemGreen
                default:
                    break
            }
        }
    }

    func setChevronIconState(to state: ExpansionState) {
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.chevronImage.transform = state == .collapsed ? CGAffineTransform(scaleX: 1, y: -1) : CGAffineTransform.identity
        }
    }
}
