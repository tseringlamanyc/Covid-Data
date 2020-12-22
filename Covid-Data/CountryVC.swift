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
        fetchCountryData(country: country)
        configureGraph()
        print(country.replacingOccurrences(of: " ", with: ""))
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
                print("this is the \(error)")
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    print(data.timeline.cases)
                    
                    let caseArray = data.timeline.cases.sorted { $0.key.getDate() < $1.key.getDate() }
                    
//                    for (_, value) in data.timeline.cases {
//                        caseArray.append(value)
//                    }
                    
                    let entries = (1...data.timeline.cases.count).map { (x) -> ChartDataEntry in
                        return ChartDataEntry(x: Double(x) , y: Double(caseArray[x - 1].value))
                    }
                    
                    let set = LineChartDataSet(entries: entries, label: "Cases")
                    set.drawCirclesEnabled = false
                    set.mode = .cubicBezier
                    
                    set.lineWidth = 3
                    
                    set.mode = .cubicBezier
                    set.drawValuesEnabled = true
                    set.valueFont = .systemFont(ofSize: 10)
                    
                    set.setColor(.white)
                    set.fill = Fill(color: .white)
                    set.fillAlpha = 0.8
                    set.drawFilledEnabled = true
                    
                    set.axisDependency = .left
                    
                    LineChartData(dataSet: set).setDrawValues(false)
                    let data = LineChartData(dataSet: set)
                    data.setDrawValues(false)
                    self?.lineGraph.data = data
                    
                }
            }
        }
    }
    
    func generateLineData() -> LineChartData {
        let entries = (2...10).map { (x) -> ChartDataEntry in
            return ChartDataEntry(x: Double(x) , y: Double(arc4random_uniform(15) + 5))
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

extension String {
    
    func getDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        let date = dateFormatter.date(from: self)
        return date ?? Date()
    }
    
    //    let date2 = convert(string: "11/12/20")
    //    let date1 = convert(string: "11/30/20")
    //    if date1 < date2 {
    //     print(“older date”)
    //    }
    //
    //    let sortedCases = casesDict.sorted { case1, case2 in
    //     return convert(string: case1.key) < convert(string: case2.key)
    //    }
}
