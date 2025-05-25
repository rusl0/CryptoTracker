//
//  CoinInfo.swift
//  CryptoTracker
//
//  Created by Ruslan Kandratsenka on 23.05.25.
//

import Foundation

struct CoinInfo {
    let id: String
    let symbol: String
    let name: String
    let price: Double
    let marketCap: Double
    let totalVolume: Double
    let maxPricePerDay: Double?
    let minPricePerDay: Double?
    let priceChangePerDay: Double?
    let priceChangePercentagePerDay: Double?
}

extension CoinInfo: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case name
        case price = "current_price"
        case marketCap = "market_cap"
        case totalVolume = "total_volume"
        case maxPricePerDay = "high_24h"
        case minPricePerDay = "low_24h"
        case priceChangePerDay = "price_change_24h"
        case priceChangePercentagePerDay = "price_change_percentage_24h"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.symbol = try container.decode(String.self, forKey: .symbol)
        self.name = try container.decode(String.self, forKey: .name)
        self.price = try container.decode(Double.self, forKey: .price)
        self.marketCap = try container.decode(Double.self, forKey: .marketCap)
        self.totalVolume = try container.decode(Double.self, forKey: .totalVolume)
        self.maxPricePerDay = try container.decode(Double?.self, forKey: .maxPricePerDay)
        self.minPricePerDay = try container.decode(Double?.self, forKey: .minPricePerDay)
        self.priceChangePerDay = try container.decode(Double?.self, forKey: .priceChangePerDay)
        self.priceChangePercentagePerDay = try container.decode(Double?.self, forKey: .priceChangePercentagePerDay)
    }
}
