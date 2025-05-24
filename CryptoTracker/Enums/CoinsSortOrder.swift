//
//  CoinsSortOrder.swift
//  CryptoTracker
//
//  Created by Ruslan Kandratsenka on 23.05.25.
//

import Foundation

enum CoinsSortOrder: String {
    case idAsc = "id_asc"
    case idDesc = "id_desc"
    case markerCapAsc = "market_cap_asc"
    case markerCapDesc = "market_cap_desc"
    case volumeAsc = "volume_asc"
    case volumeDesc = "volume_desc"
}
