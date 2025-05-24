//
//  AppCoordiantor.swift
//  CryptoTracker
//
//  Created by Ruslan Kandratsenka on 21.05.25.
//

import Foundation
import UIKit

protocol FavoritesCoordinator: AnyObject {
    func showDetail(with coinInfo: CoinInfo)
}

final class FavoritesListCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = FavoritesListViewModel(coordinator: self)
        let favoritesController = FavoritesListViewController(viewModel: viewModel)
        
        navigationController.pushViewController(favoritesController, animated: true)
    }
}

extension FavoritesListCoordinator: BackableCoordinator {
    func goBack() {
        parentCoordinator?.childDidFinish(self)
    }
}
