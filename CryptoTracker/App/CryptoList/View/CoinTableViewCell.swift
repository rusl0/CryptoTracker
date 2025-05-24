//
//  CoinTableViewCell.swift
//  CryptoTracker
//
//  Created by Ruslan Kandratsenka on 24.05.25.
//

import UIKit

class CoinTableViewCell: UITableViewCell {

    lazy var name: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var symbol: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .black.withAlphaComponent(0.8)
        return label
    }()
    
    lazy var price: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupView() {
        addSubview(name)
        addSubview(symbol)
        addSubview(price)
        setupLayout()
    }
    
    private func setupLayout() {
        name.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(2)
            make.trailing.equalToSuperview().multipliedBy(0.5)
        }
        
        symbol.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(name.snp.bottom)
            make.bottom.equalToSuperview().offset(-2)
        }
        
        price.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(name.snp.trailing)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
        }
    }

}
