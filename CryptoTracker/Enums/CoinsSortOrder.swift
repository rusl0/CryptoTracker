//
//  CoinsSortOrder.swift
//  CryptoTracker
//
//  Created by Ruslan Kandratsenka on 23.05.25.
//

import Foundation

enum CoinsSortOrder: String, CaseIterable {
    case idAsc = "id_asc"
    case idDesc = "id_desc"
    case markerCapAsc = "market_cap_asc"
    case markerCapDesc = "market_cap_desc"
    case volumeAsc = "volume_asc"
    case volumeDesc = "volume_desc"
    
    var description: String {
        switch self {
            case .idAsc:
                return "ID ASC"
            case .idDesc:
                return "ID DESC"
            case .markerCapAsc:
                return "Market Cap ASC"
            case .markerCapDesc:
                return "Market Cap DESC"
            case .volumeAsc:
                return "Volume ASC"
            case .volumeDesc:
                return "Volume DESC"
        }
    }
}
