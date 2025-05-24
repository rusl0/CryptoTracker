//
//  RequestState.swift
//  CryptoTracker
//
//  Created by Ruslan Kandratsenka on 24.05.25.
//

import Foundation

enum ErrorType {
    case decoding
    case noInternet
    case backend(Int)
}

enum RequestState {
    case idle
    case loading
    case failed(ErrorType)
}
