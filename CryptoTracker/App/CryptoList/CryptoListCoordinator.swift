//
//  AppCoordiantor.swift
//  CryptoTracker
//
//  Created by Ruslan Kandratsenka on 21.05.25.
//

import Foundation
import UIKit

protocol ListCoordinator: AnyObject {
    func showDetail(with coinInfo: CoinInfo)
    func showFavorites()
}

final class CryptoListCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = CryptoListViewModel(coordinator: self)
        let coinListController = CryptoListViewController(viewModel: viewModel)
        
        navigationController.pushViewController(coinListController, animated: true)
    }
}

extension CryptoListCoordinator: ListCoordinator {
    func showFavorites() {
        let favorites = FavoritesListCoordinator(navigationController: navigationController)
        children.append(favorites)
        favorites.parentCoordinator = self
        favorites.start()
    }
    
    func showDetail(with coinInfo: CoinInfo) {
        let detailCoordinator = CryptoListDetailCoordinator(navigationController: navigationController, coinInfo: coinInfo)
        children.append(detailCoordinator)
        detailCoordinator.parentCoordinator = self
        detailCoordinator.start()
    }
    
}
