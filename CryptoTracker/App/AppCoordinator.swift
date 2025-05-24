//
//  AppCoordinator.swift
//  CryptoTracker
//
//  Created by Ruslan Kandratsenka on 23.05.25.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let cryptoListCoordinator = CryptoListCoordinator(navigationController: navigationController)
        cryptoListCoordinator.parentCoordinator = self
        children.append(cryptoListCoordinator)
        cryptoListCoordinator.start()
    }
    
    
}
