//
//  NumberFormatters.swift
//  CryptoTracker
//
//  Created by Ruslan Kandratsenka on 24.05.25.
//

import Foundation

func currencyNumberFormatter(value: Double?) -> String {
    
    guard let value = value else { return "No data" }
    
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 3
    
    return formatter.string(from: NSNumber(value: value)) ?? "0"
}
