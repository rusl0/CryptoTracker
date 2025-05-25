//
//  CoreDataSource.swift
//  CryptoTracker
//
//  Created by Ruslan Kandratsenka on 25.05.25.
//

import Foundation
import CoreData

final class CoreDataSource {
    
    var persistent = PersistentController.shared
    
    func loadData(withOrder: CoinsSortOrder) -> [CoinInfo] {
        let fetchRequest = CoinData.fetchRequest()
        let sort = sortDesriptor(withOrder)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            let coinsData: [CoinData] = try persistent.viewContext.fetch(fetchRequest)
            return coinsData.map { $0.toInfo() }
        } catch {
            return []
        }
    }
    
    func addCoins(_ coins: [CoinInfo]) {
        let _ = coins.map { CoinData.create(from: $0, in: persistent.viewContext) }
        persistent.saveContext()
    }
    
    private func sortDesriptor(_ withOrder: CoinsSortOrder) -> NSSortDescriptor {
        switch withOrder {
            case .idAsc:
                return NSSortDescriptor(key: "id", ascending: true)
            case .idDesc:
                return NSSortDescriptor(key: "id", ascending: false)
            case .markerCapAsc:
                return NSSortDescriptor(key: "marketCap", ascending: true)
            case .markerCapDesc:
                return NSSortDescriptor(key: "marketCap", ascending: false)
            case .volumeAsc:
                return NSSortDescriptor(key: "totalVolume", ascending: true)
            case .volumeDesc:
                return NSSortDescriptor(key: "totalVolume", ascending: false)
        }
    }
}
