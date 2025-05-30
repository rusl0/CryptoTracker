//
//  CryptoListDetailViewController.swift
//  CryptoTracker
//
//  Created by Ruslan Kandratsenka on 23.05.25.
//

import Foundation
import UIKit
import DGCharts
import Combine

final class CryptoListDetailViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    var viewModel: CryptoListDetailViewModel
    
    lazy var periodSelectorView: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Day", "Week", "Month"])
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .gray.withAlphaComponent(0.2)
        chartView.rightAxis.enabled = false
        chartView.legend.enabled = false
        
        let yAxis = chartView.leftAxis
        yAxis.axisLineWidth = 2
        yAxis.drawGridLinesEnabled = false
        yAxis.labelTextColor = .black
        yAxis.axisLineColor = .black
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false
        xAxis.drawLabelsEnabled = false
        
        return chartView
    }()
    
    init(viewModel: CryptoListDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchChartData()
    }
    
    private func bindViewModel() {
        viewModel.$chartData
            .receive(on: DispatchQueue.main)
            .sink {[weak self] _ in
                self?.setData()
            }
            .store(in: &cancellables)
        
        viewModel.$dataState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                    case .failed(let error):
                        switch error {
                            case .noInternet:
                                self.showAlertMessage(title: "Alert", message: "No Internet connection\nLocal data will be used")
                            case .backend(let code):
                                if code == 429 {
                                    self.showAlertMessage(title: "Alert", message: "Too many requests")
                                }
                                break
                            case .decoding:
                                self.showAlertMessage(title: "Alert", message: "Data parsing error")
                        }
                    default:
                        break
                }
            }
            .store(in: &cancellables)
        
        viewModel.$isFavorite
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                if value {
                    self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "bookmark.fill")
                } else {
                    self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "bookmark")
                }
            }
            .store(in: &cancellables)
    }
    
    func setData() {
        if !viewModel.chartData.isEmpty {
            let set = LineChartDataSet(entries: viewModel.chartData,label: viewModel.coinInfo.name)
            set.mode = .cubicBezier
            set.drawCirclesEnabled = false
            set.lineWidth = 3
            set.setColor(.white)
            let data = LineChartData(dataSet: set)
            data.setDrawValues(false)
            lineChartView.data = data
        }
    }
    
    override func didMove(toParent parent: UIViewController?) {
        if parent == nil {
            viewModel.goBack()
        }
    }
    
    @objc func favorites(sender: UIBarButtonItem){
        viewModel.updateFavorite()
    }
    
    @objc func changePeriod(sender: UISegmentedControl) {
        
        let period: DataPeriod
        switch sender.selectedSegmentIndex {
            case 0:
                period = .day
            case 1:
                period = .week
            case 2:
                period = .month
            default:
                period = .day
                
        }
        viewModel.fetchChartData(period: period)
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.white
        
        self.title = viewModel.coinInfo.name
        
        let favorites = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(favorites(sender:)))
        
        navigationItem.rightBarButtonItem = favorites
        
        view.addSubview(periodSelectorView)
        periodSelectorView.snp.makeConstraints { make in
            make.top.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        periodSelectorView.addTarget(self, action: #selector(changePeriod(sender:)), for: .valueChanged)
        
        view.addSubview(lineChartView)
        lineChartView.snp.makeConstraints { make in
            make.top.equalTo(periodSelectorView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.25)
        }
        
        let priceView = TitleValueView()
        view.addSubview(priceView)
        priceView.snp.makeConstraints { make in
            make.top.equalTo(lineChartView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        priceView.title.text = "Price"
        priceView.value.text = currencyNumberFormatter(value: viewModel.coinInfo.price)
        
        let marketCapView = TitleValueView()
        view.addSubview(marketCapView)
        marketCapView.snp.makeConstraints { make in
            make.top.equalTo(priceView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        marketCapView.title.text = "Market Cap"
        marketCapView.value.text = currencyNumberFormatter(value: viewModel.coinInfo.marketCap)
        
        let totalVolumeView = TitleValueView()
        view.addSubview(totalVolumeView)
        totalVolumeView.snp.makeConstraints { make in
            make.top.equalTo(marketCapView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        totalVolumeView.title.text = "Total Volume"
        totalVolumeView.value.text = currencyNumberFormatter(value: viewModel.coinInfo.totalVolume)
        
        let maxPricePerDayView = TitleValueView()
        view.addSubview(maxPricePerDayView)
        maxPricePerDayView.snp.makeConstraints { make in
            make.top.equalTo(totalVolumeView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        maxPricePerDayView.title.text = "Max Price 24h"
        maxPricePerDayView.value.text = currencyNumberFormatter(value: viewModel.coinInfo.maxPricePerDay)
        
        let mimPricePerDayView = TitleValueView()
        view.addSubview(mimPricePerDayView)
        mimPricePerDayView.snp.makeConstraints { make in
            make.top.equalTo(maxPricePerDayView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        mimPricePerDayView.title.text = "Min Price 24h"
        
        mimPricePerDayView.value.text = currencyNumberFormatter(value: viewModel.coinInfo.minPricePerDay)

        let priceChangePerDayView = TitleValueView()
        view.addSubview(priceChangePerDayView)
        priceChangePerDayView.snp.makeConstraints { make in
            make.top.equalTo(mimPricePerDayView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        priceChangePerDayView.title.text = "Price Change 24h"
        priceChangePerDayView.value.text = currencyNumberFormatter(value: viewModel.coinInfo.priceChangePerDay)

        let priceChangePercentPerDayView = TitleValueView()
        view.addSubview(priceChangePercentPerDayView)
        priceChangePercentPerDayView.snp.makeConstraints { make in
            make.top.equalTo(priceChangePerDayView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        priceChangePercentPerDayView.title.text = "Price Change % 24h"
        priceChangePercentPerDayView.value.text = currencyNumberFormatter(value: viewModel.coinInfo.priceChangePercentagePerDay)
    }
}

extension CryptoListDetailViewController: ChartViewDelegate {
    
}

