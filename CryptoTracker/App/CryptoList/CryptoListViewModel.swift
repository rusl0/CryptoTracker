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
    private var coreDataDataSoource: CoreDataSource = CoreDataSource()
    private var filtered: [CoinInfo] = []
    private var total: [CoinInfo] = []
    private var currentPage = 1
    
    @Published private(set) var cryptCoinsData: [CoinInfo]
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
        let sortOrder: CoinsSortOrder
        if let rawSortOrder = UserDefaults.standard.string(forKey: DefaultsKeys.sortOrder.rawValue) {
            sortOrder = CoinsSortOrder(rawValue: rawSortOrder)!
        } else {
            sortOrder = .markerCapDesc
            UserDefaults.standard.set(sortOrder.rawValue, forKey: DefaultsKeys.sortOrder.rawValue)
        }
        
        let requestUrl = EndpointAPI.coinsMarket(page: currentPage,sortOrder: sortOrder).url
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
                            if self.dataState != .failed(.noInternet) {
                                self.dataState = .failed(.noInternet)
                            }
                            self.cryptCoinsData = self.coreDataDataSoource.loadData(withOrder: sortOrder)
                        }
                        if error.isResponseSerializationError {
                            self.dataState = .failed(.decoding)
                        }
                        print(error)
                    case .finished:
                        break
                        
                }
            } receiveValue: { [weak self] value in
                guard let self = self else {return}
                
                self.coreDataDataSoource.addCoins(value)
                
                if appending {
                    self.total.append(contentsOf: value)
                } else {
                    self.currentPage = 1
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
    
    func loadMoreData() {
        currentPage += 1
        fetchData(appending: true)
    }
}
