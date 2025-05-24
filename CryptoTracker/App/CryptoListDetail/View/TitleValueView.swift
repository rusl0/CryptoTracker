//
//  TitleValueView.swift
//  CryptoTracker
//
//  Created by Ruslan Kandratsenka on 24.05.25.
//

import UIKit
import SnapKit

final class TitleValueView: UIView {
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    lazy var value: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.textAlignment = .right
        return label
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
        addSubview(title)
        addSubview(value)
        setupLayout()
    }
    
    private func setupLayout() {
        title.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.bottom.equalToSuperview().offset(2)
            make.trailing.lessThanOrEqualTo(value.snp.leading)
        }
        
        value.snp.makeConstraints { make in
            make.leading.equalTo(title.snp.trailing)
            make.top.bottom.equalToSuperview().offset(2)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
}
