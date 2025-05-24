//
//  CryptoListDetailViewModel.swift
//  CryptoTracker
//
//  Created by Ruslan Kandratsenka on 23.05.25.
//

import Foundation
import Combine
import DGCharts
import Alamofire

final class CryptoListDetailViewModel {
    private var cancellables = Set<AnyCancellable>()
    private var coordinator: DetailCoordinator
    
    let coinInfo: CoinInfo
    
    @Published var dataState: RequestState = .idle
    @Published var chartData: [ChartDataEntry] = []
    
    init(coordinator : DetailCoordinator, coinInfo: CoinInfo) {
        self.coinInfo = coinInfo
        self.coordinator = coordinator
    }
    
    func fetchChartData(period: DataPeriod = .day) {
        let requestUrl = EndpointAPI.coinsChartData(id: coinInfo.id, dataPeriod: period).url
        
        AF.request(requestUrl)
            .validate()
            .publishDecodable(type: CoinChartData.self)
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
                        print(error)
                    case .finished:
                        break
                        
                }
            } receiveValue: { [weak self] value in
                guard let self = self else {return}
                
                self.chartData = value.prices.enumerated().map { (index,price) in
                    ChartDataEntry(x: Double(index), y: price[1], data: Date(timeIntervalSince1970: price[0]))
                }
            }
            .store(in: &cancellables)
            
    }
    
    func goBack() {
        coordinator.goBack()
    }
}
