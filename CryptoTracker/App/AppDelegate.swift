//
//  AppDelegate.swift
//  CryptoTracker
//
//  Created by Ruslan Kandratsenka on 20.05.25.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navContrl = UINavigationController()
        appCoordinator = AppCoordinator(navigationController: navContrl)
        appCoordinator?.start()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navContrl
        window?.makeKeyAndVisible()
        return true
    }
}

