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
    
    lazy var priceView: TitleValueView = {
        let view = TitleValueView() 
        return view
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
        view.backgroundColor = UIColor.white
        
        self.navigationController?.title = viewModel.coinInfo.name
        
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
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        setData()
        
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
}

extension CryptoListDetailViewController: ChartViewDelegate {
    
}

