# Covid-Data

## Description

This application allows a user to look up covid data for countries all around the world. The user can also look up cases for specific states in the US. This app provides the case data for the past 30 days as a graph. 

This application has 2 tab bars (worlds category and USA category). The worlds tab uses collection view layout and has section named after the continent. Each continent has their respective countries. The other tab shows all 50 states. 

## Screenshots
<img src="Assets/Continents.png" alt="JobHistory" width="305" height="700" /> <img src="Assets/Usa.png" alt="JobHistory" width="305" height="700" />

## Gif of grpah
<img src="Assets/graph.png" alt="JobHistory" width="350" height="700" />

## Code Snippets

### Populating the charts with API Data
```swift
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
```

### Adding shadows to the collection view cell
``` swift 
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 1)
            cell.layer.shadowRadius = 2.0
            cell.layer.shadowOpacity = 1.0
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
```
## Tools & Frameworks used
Xcode 12, Swift 5, UIKit, Foundation, MapKit

## Cocoa Pods & API Used
#### Charts - https://github.com/danielgindi/Charts
#### Disease.sh - https://github.com/disease-sh/api
