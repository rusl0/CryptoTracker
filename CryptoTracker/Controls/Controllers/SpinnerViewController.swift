//
//  SpinnerViewController.swift
//  CryptoTracker
//
//  Created by Ruslan Kandratsenka on 25.05.25.
//

import UIKit
import SnapKit

class SpinnerViewController: UIViewController {
    private var spinner = UIActivityIndicatorView(style: .large)
    
    override func loadView() {
        self.view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.1)
        
        view.addSubview(spinner)
        spinner.startAnimating()
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
