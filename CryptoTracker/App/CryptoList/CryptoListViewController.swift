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
    var coordinator: CryptoListCoordinator?
    
    private var cryptoList: UITableView!
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: CryptoListViewModel, coordinator: CryptoListCoordinator? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCoinList()
        bindViewModel()
        viewModel.fetchData()
    }

    private func bindViewModel() {
        viewModel.$cryptCoinsData
            .receive(on: DispatchQueue.main)
            .sink {[weak self] _ in
                self?.cryptoList.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func setupCoinList() {
        cryptoList = UITableView()
        cryptoList.register(UITableViewCell.self, forCellReuseIdentifier: "CoinCell")
        cryptoList.dataSource = self
        cryptoList.delegate = self
        
        view.addSubview(cryptoList)
        
        cryptoList.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoinCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = coinData.name
        content.secondaryText = String(coinData.price)
        cell.contentConfiguration = content
        
        return cell
    }
}
