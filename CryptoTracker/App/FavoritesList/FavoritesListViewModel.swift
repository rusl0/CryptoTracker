//
//  CryptoListViewModel.swift
//  CryptoTracker
//
//  Created by Ruslan Kandratsenka on 21.05.25.
//

import Foundation
import Combine
import Alamofire

final class FavoritesListViewModel {
    private var cancellables = Set<AnyCancellable>()
    
    var coordinator: BackableCoordinator
    private var coreDataDataSoource: CoreDataSource = CoreDataSource()
    private let timer: Timer.TimerPublisher
    
    private var favorites: [String] = []
    
    @Published var cryptCoinsData: [CoinInfo]
    @Published var dataState: RequestState
    
    init(coordinator: BackableCoordinator) {
        self.coordinator = coordinator
        self.cryptCoinsData = []
        self.dataState = .idle
        timer = Timer.publish(every: 60, on: .main, in: .default)
    }
    
    func startUpdating() {
        
        guard let array = UserDefaults.standard.array(forKey: DefaultsKeys.favorites.rawValue) as? [String],
        !array.isEmpty else {
            return
        }
        favorites = array
        
        timer
            .autoconnect()
            .sink { _ in
                self.fetchData()
            }
            .store(in: &cancellables)
    }
    
    func stopUpdationg() {
        timer.connect().cancel()
    }
    
    func fetchData()
    {
        let requestUrl = EndpointAPI.coinsMarket(ids: favorites).url
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
                                let ids = UserDefaults.standard.array(forKey: DefaultsKeys.favorites.rawValue) as? [String] ?? []
                                self.cryptCoinsData = self.coreDataDataSoource.loadData(idList: ids)
                                self.dataState = .failed(.noInternet)
                            }
                        }
                        if error.isResponseSerializationError {
                            self.dataState = .failed(.decoding)
                        }
                    case .finished:
                        break
                        
                }
            } receiveValue: { [weak self] value in
                guard let self = self else {return}
                self.cryptCoinsData = value
            }
            .store(in: &cancellables)
    }
    
    func goBack() {
        coordinator.goBack()
    }
}
