//
//  CoinData.swift
//  CryptoTracker
//
//  Created by Ruslan Kandratsenka on 25.05.25.
//

import Foundation
import CoreData

extension CoinData {
    static func create(from coin: CoinInfo, in context: NSManagedObjectContext) -> CoinData {
        let newCoin = CoinData(context: context)
        
        newCoin.id = coin.id
        newCoin.symbol = coin.symbol
        newCoin.name = coin.name
        newCoin.price = coin.price ?? Double.nan
        newCoin.marketCap = coin.marketCap ?? Double.nan
        newCoin.maxPrice = coin.maxPricePerDay ?? Double.nan
        newCoin.minPrice = coin.minPricePerDay ?? Double.nan
        newCoin.priceChange = coin.priceChangePerDay ?? Double.nan
        newCoin.priceChangePercent = coin.priceChangePercentagePerDay ?? Double.nan
        
        return newCoin
    }
    
    func toInfo() -> CoinInfo {
        .init(
            id: self.id ?? "",
            symbol: self.symbol ?? "",
            name: self.name ?? "",
            price: self.price.isNaN ? nil : self.price,
            marketCap: self.marketCap.isNaN ? nil : self.marketCap,
            totalVolume: self.totalVolume.isNaN ? nil : self.totalVolume,
            maxPricePerDay: self.maxPrice.isNaN ? nil : self.maxPrice,
            minPricePerDay: self.minPrice.isNaN ? nil : self.minPrice,
            priceChangePerDay: self.priceChange.isNaN ? nil : self.priceChange,
            priceChangePercentagePerDay: self.priceChangePercent.isNaN ? nil : self.priceChangePercent
        )
    }
}
