//
//  CountryVC.swift
//  Covid-Data
//
//  Created by Tsering Lama on 12/17/20.
//

import UIKit
import Charts

class CountryVC: UIViewController {
    
    private var country: String
    
    let apiClinet = APIClient()
    
    var chartData = [ChartDataEntry]()
    
    @IBOutlet weak var lineGraph: LineChartView!
    
    init?(coder: NSCoder, country: String) {
        self.country = country
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        fetchCountryData(country: country.trimmingCharacters(in: .whitespaces))
        configureGraph()
        print(country.trimmingCharacters(in: .whitespaces))
    }
    
    func configureGraph() {
        
        lineGraph.backgroundColor = .systemBlue
        lineGraph.rightAxis.enabled = false
        
        let yAxis = lineGraph.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(8, force: false)
        yAxis.labelTextColor = .systemYellow
        yAxis.axisLineColor = .systemYellow
        
        let xAxis = lineGraph.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .boldSystemFont(ofSize: 12)
        xAxis.setLabelCount(8, force: false)
        xAxis.labelTextColor = .systemYellow
        xAxis.axisLineColor = .systemYellow
        
        lineGraph.animate(xAxisDuration: 2.5)
    }
    
    func fetchCountryData(country: String) {
        apiClinet.getCaseData(country: country) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                DispatchQueue.main.async { [self] in
                    //dump(data.timeline.cases)
                    print(data.timeline.cases.count)
                    
                    for (key, value) in data.timeline.cases {
                        
                       self?.chartData.append(ChartDataEntry(x: Double(data.timeline.cases.count), y: Double(value)))
                        
                        print(key.count)
                        
                        let set = LineChartDataSet(entries: self?.chartData, label: "Cases")
                        set.drawCirclesEnabled = false
                        set.mode = .cubicBezier
                        
                        set.lineWidth = 3
                                            
                        set.mode = .cubicBezier
                        set.drawValuesEnabled = true
                        set.valueFont = .systemFont(ofSize: 10)
                        
                        set.axisDependency = .left
                        
                        LineChartData(dataSet: set).setDrawValues(false)
                        let data = LineChartData(dataSet: set)
                        data.setDrawValues(false)
                        self?.lineGraph.data = self?.generateLineData()
                    }
                }
            }
        }
    }
    
    func generateLineData() -> LineChartData {
        let entries = (0..<31).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i) , y: Double(arc4random_uniform(15) + 5))
        }
        
        let set = LineChartDataSet(entries: entries, label: "Cases")
        
        set.drawCirclesEnabled = false
        set.mode = .cubicBezier
        
        set.lineWidth = 2.5
        
        set.circleRadius = 5
        set.circleHoleRadius = 2.5
        
        set.mode = .cubicBezier
        set.drawValuesEnabled = true
        set.valueFont = .systemFont(ofSize: 10)
        
        set.setColor(.white)
        set.fill = Fill(color: .white)
        set.fillAlpha = 0.8
        set.drawFilledEnabled = true 
        
        set.axisDependency = .left
        
        LineChartData(dataSet: set).setDrawValues(false)
        
        return LineChartData(dataSet: set)
    }
}

extension CountryVC: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
}
