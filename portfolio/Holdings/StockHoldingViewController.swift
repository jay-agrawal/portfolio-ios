//
//  StockHoldingViewController.swift
//  upstox
//
//  Created by Jayesh Agrawal on 16/11/24.
//

import UIKit

//MARK: - Class
final class StockHoldingViewController: PortfolioBaseViewController {

    //MARK: - UIComponenets
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let expandableView = BottomExpandableView()

    //MARK: - Properties
    private let viewModel: StockHoldingViewModel
    private var diffableDataSource: UITableViewDiffableDataSource<Section, StockHolding>!

    //MARK: - Init
    init() {
        self.viewModel = StockHoldingViewModel()
        super.init(nibName: nil, bundle: .main)
        view.backgroundColor = UIColor(hexString: "#F5F5F5")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Methods
    override func viewDidLoad() {
        setupViewController()
        setupTableView()
        setupSubviews()
        setupDataSource()
        bindViewModel()
        viewModel.fetchData()
    }

    private func setupDataSource() {
        diffableDataSource = UITableViewDiffableDataSource(tableView: tableView,
                                                           cellProvider: { tableView, indexPath, itemIdentifier in
            let cell: StockHoldingTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setData(with: itemIdentifier)
            return cell
        })
    }

    private func setupViewController() {
        self.title = "Portfolio"
    }

    private func bindViewModel() {
        viewModel.updatedState = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.updateFromViewModel()
            }
        }
    }

    private func updateFromViewModel() {
        let state = viewModel.state
        switch state {
            case .loading:
                self.showLoadingState()
            case .loaded(let details):
                self.showStockHoldings(details)
            case .error:
                self.showErrorState()
        }
    }

    private func showStockHoldings(_ stockHoldings: StocksDataResponse) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, StockHolding>()
        snapshot.appendSections([.first])
        snapshot.appendItems(stockHoldings.data.userHolding)
        hideLoadingSpinner()
        diffableDataSource.apply(snapshot, animatingDifferences: false)
        setupExpandableView()
        expandableView.showPortfolioSummary(for: viewModel.portfolioSummary)
    }

    private func showLoadingState() {
        removeError()
        showLoadingSpinner()
    }

    private func showErrorState() {
        hideLoadingSpinner()
        showGenericError()
    }

    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        tableView.registerClassWithDefaultIdentifier(cellClass: StockHoldingTableViewCell.self)
        tableView.tableHeaderView?.backgroundColor = .white
    }

    private func setupSubviews() {
        view.addSubviews(tableView)
        tableView.showsVerticalScrollIndicator = false
        // Set up Auto Layout constraints

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70)
        ])
    }

    private func setupExpandableView() {
        // Configure expandable view
        view.addSubviews(expandableView)
        NSLayoutConstraint.activate([
            expandableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            expandableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            expandableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
        ])
    }
}

