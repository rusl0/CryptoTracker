//
//  SpinnerViewController.swift
//  CryptoTracker
//
//  Created by Ruslan Kandratsenka on 25.05.25.
//

import UIKit
import SnapKit

class SpinnerViewController: UIViewController {
    override func loadView() {
        let spinner = SpinnerView()
        self.view = spinner
        view.backgroundColor = UIColor(white: 0, alpha: 0.1)
        spinner.startAnimation()
    }
}
