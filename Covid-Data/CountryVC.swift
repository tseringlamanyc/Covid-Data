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
        navigationItem.title = country.uppercased()
        view.backgroundColor = .systemBackground
        fetchAllCountryData(country: country)
        configureGraph()
    }
    
    func configureGraph() {
        
        lineGraph.backgroundColor = .systemBackground
        lineGraph.rightAxis.enabled = false
        
        let yAxis = lineGraph.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(8, force: false)
        yAxis.labelTextColor = .black
        yAxis.axisLineColor = .black
        
        let xAxis = lineGraph.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .boldSystemFont(ofSize: 12)
        xAxis.setLabelCount(8, force: false)
        xAxis.labelTextColor = .black
        xAxis.axisLineColor = .black
        
        lineGraph.animate(xAxisDuration: 2.5)
    }
    
    func fetchAllCountryData(country: String) {
        apiClinet.getAllCaseData { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("this is the \(error)")
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    
                    var allCases = [String: Int]()
                    
                    for (countries) in data {
                        if country == countries.country || (countries.province != nil) {
                            allCases = countries.timeline.cases
                        }
                    }
                    
                    
                    let caseArray = allCases.sorted { $0.key.getDate() < $1.key.getDate() }
                    
                    let entries = (1...30).map { (x) -> ChartDataEntry in
                        return ChartDataEntry(x: Double(x) , y: Double(caseArray[x - 1].value))
                    }
                    
                    let set = LineChartDataSet(entries: entries, label: "Cases")
                    set.drawCirclesEnabled = false
                    set.mode = .cubicBezier
                    
                    set.lineWidth = 2.5
                    
                    set.mode = .cubicBezier
                    set.drawValuesEnabled = true
                    set.valueFont = .systemFont(ofSize: 10)
                    
                    set.setColor(.systemYellow)
                    set.fill = Fill(color: .systemRed)
                    set.fillAlpha = 0.8
                    set.drawFilledEnabled = true
                    
                    set.axisDependency = .left
                    
                    let data = LineChartData(dataSet: set)
                    data.setDrawValues(false)
                    self?.lineGraph.data = data
                }
            }
        }
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
}
