//
//  Coin.swift
//  CryptoTracker
//
//  Created by Ruslan Kandratsenka on 23.05.25.
//

import Foundation
 
struct Coin: Decodable {
    let id: String
    let symbol: String
    let name: String
}
