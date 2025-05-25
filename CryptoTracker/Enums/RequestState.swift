//
//  RequestState.swift
//  CryptoTracker
//
//  Created by Ruslan Kandratsenka on 24.05.25.
//

import Foundation

enum ErrorType: Equatable {
    case decoding
    case noInternet
    case backend(Int)
    
    static func ==(lhs: ErrorType, rhs: ErrorType) -> Bool {
        switch (lhs, rhs) {
            case (.decoding, .decoding):
                return true
            case (.noInternet, .noInternet):
                return true
            case (let .backend(val1), let .backend(val2)):
                return val1 == val2
            default:
                return false
        }
    }
}

enum RequestState: Equatable {
    case idle
    case loading
    case failed(ErrorType)
    
    static func ==(lhs: RequestState, rhs: RequestState) -> Bool {
        switch (lhs, rhs) {
            case (.idle, .idle):
                return true
            case (.loading, .loading):
                return true
            case (let .failed(val1), let .failed(val2)):
                return val1 == val2
            default:
                return false
        }
    }
}
