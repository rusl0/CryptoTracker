//
//  CryptoListDetailCoordinator.swift
//  CryptoTracker
//
//  Created by Ruslan Kandratsenka on 23.05.25.
//

import Foundation
import UIKit

protocol DetailCoordinator: AnyObject {
    func goBack()
}

final class CryptoListDetailCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    let dataItem: CoinInfo
    
    init(navigationController: UINavigationController, coinInfo: CoinInfo) {
        self.navigationController = navigationController
        self.dataItem = coinInfo
    }
    
    func start() {
        let viewModel = CryptoListDetailViewModel(coordinator: self,coinInfo: dataItem)
        let coinListController = CryptoListDetailViewController(viewModel: viewModel)
        
        navigationController.pushViewController(coinListController, animated: true)
    }
}

extension CryptoListDetailCoordinator: DetailCoordinator {
    func goBack() {
        parentCoordinator?.childDidFinish(self)
    }
}
