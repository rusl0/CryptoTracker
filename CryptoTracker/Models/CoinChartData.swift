//
//  CoinChartData.swift
//  CryptoTracker
//
//  Created by Ruslan Kandratsenka on 23.05.25.
//

import Foundation


// Prices item [0] - timestamp
//             [1] - price value

struct CoinChartData: Decodable {
    let prices: [[Double]]
}
 
