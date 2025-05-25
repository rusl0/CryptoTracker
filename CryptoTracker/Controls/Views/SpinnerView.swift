//
//  SpinnerView.swift
//  CryptoTracker
//
//  Created by Ruslan Kandratsenka on 25.05.25.
//

import UIKit

class SpinnerView: UIView {

    lazy private var spinner = {
        let activity = UIActivityIndicatorView(style: .large)
        return activity
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        addSubview(spinner)
        spinner.startAnimating()
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func startAnimation() {
        spinner.startAnimating()
    }
    
    func stopAnimation() {
        spinner.stopAnimating()
    }
}
