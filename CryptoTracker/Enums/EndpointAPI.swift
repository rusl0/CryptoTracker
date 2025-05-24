//
//  EndpointAPI.swift
//  CryptoTracker
//
//  Created by Ruslan Kandratsenka on 23.05.25.
//

import Foundation

enum EndpointAPI {
    case coinList
    case coinsMarket(ids: [String] = [], page: Int = 1, countPerPage: Int = 200, sortOrder: CoinsSortOrder = .markerCapDesc)
    case coinsChartData(id: String, dataPeriod: DataPeriod = .day)
}

extension EndpointAPI {
    
    var baseHost:String {
        return "api.coingecko.com"
    }
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = baseHost
        
        switch self {
            case .coinList:
                components.path = "/api/v3/coins/list"
            case .coinsMarket(let ids, let page, let countPerPage, let sortOrder):
                components.path = "/api/v3/coins/markets"
                components.queryItems = [
                    URLQueryItem(name: "page", value: String(page)),
                    URLQueryItem(name: "per_page", value: String(countPerPage)),
                    URLQueryItem(name: "order", value: sortOrder.rawValue),
                    URLQueryItem(name: "vs_currency", value: "usd"),
                    URLQueryItem(name: "ids", value: ids.joined(separator: ","))
                ]
            case .coinsChartData(let id, let dataPeriod):
                components.path = "/api/v3/coins/\(id)/market_chart"
                components.queryItems = [
                    URLQueryItem(name: "days", value: dataPeriod.rawValue),
                    URLQueryItem(name: "vs_currency", value: "usd")
                ]
        }
        
        guard let url = components.url else {
            preconditionFailure("Invelid URL components: \(components)")
        }
        
        return url
    }
    
    
}
