//
//  ViewController.swift
//  CryptoTracker
//
//  Created by Ruslan Kandratsenka on 20.05.25.
//

import UIKit
import Combine
import SnapKit

final class FavoritesListViewController: UIViewController {

    var viewModel: FavoritesListViewModel
    private var cancellables = Set<AnyCancellable>()
    
    lazy var cryptoList: UITableView = {
        let tableView = UITableView()
        tableView.register(CoinTableViewCell.self, forCellReuseIdentifier: "CoinCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView?.isHidden = true
        return tableView
    }()
    
    init(viewModel: FavoritesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
        viewModel.startUpdating()
        viewModel.fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.stopUpdationg()
        super.viewWillDisappear(animated)
    }

    private func bindViewModel() {
        viewModel.$cryptCoinsData
            .receive(on: DispatchQueue.main)
            .sink {[weak self] _ in
                guard let self = self else {return}
                self.cryptoList.reloadData()
            }
            .store(in: &cancellables)
        viewModel.$dataState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else {return}
                switch value {
                    case .failed(let error):
                        switch error {
                            case .noInternet:
                                self.showAlertMessage(title: "Alert", message: "No Internet connection\nLocal data will be used")
                            case .backend(let code):
                                if code == 429 {
                                    self.showAlertMessage(title: "Alert", message: "Too many requests")
                                } else {
                                    self.showAlertMessage(title: "Alert", message: "Server error")
                                }
                            case .decoding:
                                self.showAlertMessage(title: "Alert", message: "Data parsing error")
                        }
                    default:
                        break
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        title = "Favorites"
        view.addSubview(cryptoList)
        
        cryptoList.dataSource = self
        cryptoList.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func didMove(toParent parent: UIViewController?) {
        if parent == nil {
            viewModel.goBack()
        }
    }
}

extension FavoritesListViewController: UITableViewDataSource {
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

