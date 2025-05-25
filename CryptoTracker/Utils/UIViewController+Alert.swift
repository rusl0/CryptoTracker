//
//  UIViewController+Alert.swift
//  CryptoTracker
//
//  Created by Ruslan Kandratsenka on 25.05.25.
//

import UIKit

extension UIViewController {
    public func showAlertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}
