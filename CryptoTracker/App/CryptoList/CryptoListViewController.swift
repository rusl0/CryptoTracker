//
//  ViewController.swift
//  CryptoTracker
//
//  Created by Ruslan Kandratsenka on 20.05.25.
//

import UIKit
import Combine
import SnapKit

final class CryptoListViewController: UIViewController {
    
    var viewModel: CryptoListViewModel
    
    lazy private var cryptoList: UITableView = {
        let tableView = UITableView()
        tableView.register(CoinTableViewCell.self, forCellReuseIdentifier: "CoinCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView?.isHidden = true
        return tableView
    }()
    
    lazy private var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        return refresh
    }()
    
    lazy private var spinner: SpinnerViewController = {
        let controller = SpinnerViewController()
        return controller
    }()
    
    lazy private var seachController = {
        let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = true
        search.searchBar.placeholder = "Search..."
        return search
    }()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: CryptoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearch()
        setupUI()
        bindViewModel()
        viewModel.fetchData()
    }
    
    private func bindViewModel() {
        viewModel.$cryptCoinsData
            .receive(on: DispatchQueue.main)
            .sink {[weak self] _ in
                guard let self = self else {return}
                self.cryptoList.reloadData()
                guard let refresh = self.cryptoList.refreshControl else { return }
                
                if refresh.isRefreshing {
                    refresh.endRefreshing()
                }
            }
            .store(in: &cancellables)
        viewModel.$dataState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else {return}
                switch value {
                    case .loading:
                        self.spinnerView(needShow: true)
                    case .failed(_):
                        self.spinnerView(needShow: false)
                    case .idle:
                        self.spinnerView(needShow: false)
                }
            }
            .store(in: &cancellables)
        viewModel.$isFiltered
            .receive(on: DispatchQueue.main)
            .sink { [weak self] filtered in
                guard let self = self else {return}
                if filtered {
                    self.cryptoList.refreshControl = nil
                    //disable pagination
                } else {
                    self.cryptoList.refreshControl = self.refreshControl
                    // enable pagination
                }
            }
            .store(in: &cancellables)
    }
    
    private func spinnerView(needShow: Bool) {
        if needShow {
            addChild(spinner)
            spinner.view.frame = view.frame
            view.addSubview(spinner.view)
            spinner.didMove(toParent: self)
        } else {
            spinner.willMove(toParent: nil)
            spinner.view.removeFromSuperview()
            spinner.removeFromParent()
        }
    }
    
    private func setupSearch() {
        seachController.searchResultsUpdater = self
        seachController.searchBar.delegate = self
        self.navigationItem.searchController = seachController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupUI() {
        let favorites = UIBarButtonItem(image: UIImage(systemName: "book"), style: .plain, target: self, action: #selector(favorites(sender:)))
        
        navigationItem.leftBarButtonItem = favorites
        
        view.addSubview(cryptoList)
        
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        cryptoList.refreshControl = refreshControl
        cryptoList.dataSource = self
        cryptoList.delegate = self
        cryptoList.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        viewModel.fetchData()
    }
    
    @objc func favorites(sender: UIBarButtonItem){
        viewModel.showFavorites()
    }
}

extension CryptoListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.clearFilter()
    }
}

extension CryptoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive {
            viewModel.applyFilter(coinName: searchController.searchBar.text ?? "")
        }
    }
}

extension CryptoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.showDetailWithItem(indexPath.row)
    }
}

extension CryptoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cryptCoinsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let coinData = viewModel.cryptCoinsData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoinCell", for: indexPath) as! CoinTableViewCell
        
        cell.name.text = coinData.name
        cell.symbol.text = coinData.symbol
        cell.price.text = currencyNumberFormatter(value: coinData.price)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layoutIfNeeded()
    }
}
