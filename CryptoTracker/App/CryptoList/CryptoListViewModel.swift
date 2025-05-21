//
//  CryptoListViewModel.swift
//  CryptoTracker
//
//  Created by Ruslan Kandratsenka on 21.05.25.
//

import Foundation
import Combine

struct TestData {
    let text: String
    let detail: String
}

final class CryptoListViewModel {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var crytoCoinsData: [TestData] = []
    
    func fetchData() {
        Just([
            TestData(text: "qwe", detail: "asd"),
            TestData(text: "qwe", detail: "asd"),
            TestData(text: "qwe", detail: "asd"),
            TestData(text: "qwe", detail: "asd")
        ])
        .delay(for: .seconds(1), scheduler: DispatchQueue.main)
        .assign(to: &$crytoCoinsData)
    }
}
