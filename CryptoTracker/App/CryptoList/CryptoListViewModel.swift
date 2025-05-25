//
//  CryptoListViewModel.swift
//  CryptoTracker
//
//  Created by Ruslan Kandratsenka on 21.05.25.
//

import Foundation
import Combine
import Alamofire

final class CryptoListViewModel {
    private var cancellables = Set<AnyCancellable>()
    
    var coordinator: ListCoordinator
    
    private var filtered: [CoinInfo] = []
    private var total: [CoinInfo] = []
    
    @Published private(set)  var cryptCoinsData: [CoinInfo]
    @Published private(set) var dataState: RequestState
    @Published private(set) var isFiltered: Bool
    
    init(coordinator: ListCoordinator) {
        self.coordinator = coordinator
        self.cryptCoinsData = []
        self.dataState = .loading
        self.isFiltered = false
    }
    
    func fetchData(appending: Bool = false)
    {
        let requestUrl = EndpointAPI.coinsMarket().url
        AF.request(requestUrl)
            .validate()
            .publishDecodable(type: [CoinInfo].self)
            .value()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else {return}
                switch completion {
                    case .failure(let error):
                        if let code = error.responseCode {
                            self.dataState = .failed(.backend(code))
                        }
                        if error.isSessionTaskError {
                            self.dataState = .failed(.noInternet)
                        }
                        if error.isResponseSerializationError {
                            self.dataState = .failed(.decoding)
                        }
                    case .finished:
                        break
                        
                }
            } receiveValue: { [weak self] value in
                guard let self = self else {return}
                
                if appending {
                    self.total.append(contentsOf: value)
                } else {
                    self.total = value
                }
                
                self.cryptCoinsData = self.total
                self.dataState = .idle
            }
            .store(in: &cancellables)
    }
    
    func applyFilter(coinName: String) {
        if !coinName.isEmpty {
            cryptCoinsData = total.filter{ info in
                info.name.lowercased().hasPrefix(coinName.lowercased())
            }
        } else {
            cryptCoinsData = total
        }
        isFiltered = true
    }
    
    func clearFilter() {
        if isFiltered {
            cryptCoinsData = total
            isFiltered = false
        }
    }
    
    func showDetailWithItem(_ index: Int) {
        if index < cryptCoinsData.count {
            coordinator.showDetail(with: cryptCoinsData[index])
        }
    }
    
    func showFavorites() {
        coordinator.showFavorites()
    }
}
