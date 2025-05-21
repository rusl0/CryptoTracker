//
//  AppCoordiantor.swift
//  CryptoTracker
//
//  Created by Ruslan Kandratsenka on 21.05.25.
//

import Foundation
import UIKit

final class CryptoListCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = CryptoListViewModel()
        let coinListController = CryptoListViewController(viewModel: viewModel)
        coinListController.coordinator = self
        
        navigationController.pushViewController(coinListController, animated: true)
    }
}
