//
//  CountryVC.swift
//  Covid-Data
//
//  Created by Tsering Lama on 12/17/20.
//

import UIKit
import MapKit
import Charts

class CountryVC: UIViewController {
    
    private var country: String
    
    let apiClinet = APIClient()
    
    @IBOutlet weak var lineGraph: LineChartView!
    @IBOutlet weak var population: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var totalCase: UILabel!
    @IBOutlet weak var todaysCase: UILabel!
    @IBOutlet weak var totalDeath: UILabel!
    @IBOutlet weak var todaysDeath: UILabel!
    
    init?(coder: NSCoder, country: String) {
        self.country = country
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let cornerRadius: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = country
        view.backgroundColor = #colorLiteral(red: 0.7361819148, green: 0.9366590381, blue: 0.9016157985, alpha: 1)
        fetchAllCountryData(country: country)
        getCountryInfo(country: country)
        configureGraph()
        configureLabels()
    }
    
    func configureLabels() {
        population.layer.cornerRadius = cornerRadius
        totalCase.layer.cornerRadius = cornerRadius
        todaysCase.layer.cornerRadius = cornerRadius
        totalDeath.layer.cornerRadius = cornerRadius
        todaysDeath.layer.cornerRadius = cornerRadius
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
                        if country == countries.country || country.lowercased() == countries.province?.lowercased() {
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
                    
                    set.lineWidth = 2.0
                    
                    set.mode = .cubicBezier
                    set.drawValuesEnabled = true
                    set.valueFont = .systemFont(ofSize: 10)
                    
                    set.setColor(.systemRed)
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
    
    func getCountryInfo(country: String) {
        apiClinet.getACountry(country: country) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let countryData):
                DispatchQueue.main.async {
                    self?.population.text = "Population - \(countryData.population.getComma())"
                    self?.totalCase.text = "Total Cases - \(countryData.cases.getComma())"
                    self?.todaysCase.text = "Today's Case - \(countryData.todayCases.getComma())"
                    self?.totalDeath.text = "Total Death - \(countryData.deaths.getComma())"
                    self?.todaysDeath.text = "Today's death - \(countryData.todayDeaths.getComma())"
                    self?.loadMap(lat: countryData.countryInfo.lat, long: countryData.countryInfo.long, country: country)
                }
            }
        }
    }
    
    func loadMap(lat: Double, long: Double, country: String) {
        let userLat = Double(lat)
        let userLon = Double(long)
        
        let userLocation = CLLocationCoordinate2D(latitude: userLat, longitude: userLon)
        let span = MKCoordinateSpan(latitudeDelta: 40, longitudeDelta: 40)
        let region = MKCoordinateRegion(center: userLocation, span: span)
        mapView.setRegion(region, animated: true)
        mapView.isZoomEnabled = false
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: userLat, longitude: userLon)
        annotation.title = country
        mapView.addAnnotation(annotation)
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

extension Int {
    
    func getComma() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let commaNum =  numberFormatter.string(from: NSNumber(value: self))
        return commaNum ?? ""
    }
}
