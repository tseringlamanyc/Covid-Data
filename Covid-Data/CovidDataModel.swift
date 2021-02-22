//
//  CovidDataModel.swift
//  Covid-Data
//
//  Created by Tsering Lama on 12/15/20.
//

import Foundation

// MARK:- CONTINENTES
struct AllContientData: Decodable, Hashable {
    let continent: String
    let countries: [String]
}

// MARK:- CASES
struct CasesData: Decodable {
    let country: String
    let timeline: Timeline
}

struct Timeline: Decodable {
    let cases: [String: Int]
}

// MARK:- FLAG
struct AllCountries: Decodable, Hashable {
    let country: String
    let countryInfo: CountryInfo
    let continent: String
}

struct AllCaseData: Decodable, Hashable {
    let country: String
    let province: String?
    let timeline: Timeline2
}

struct Timeline2: Decodable, Hashable {
    let cases: [String: Int]
}

struct CountryInfo: Decodable, Hashable {
    let flag: String
}

// MARK:- SPECIFIC COUNTRY
struct CountryData: Decodable, Hashable {
    let countryInfo: CountryInfo2
    let cases, todayCases, deaths, todayDeaths, population: Int
}

struct CountryInfo2: Decodable, Hashable {
    let lat: Double
    let long: Double
}

// MARK:- USA ONLY DATA
struct USAData: Decodable, Hashable {
    let state: String
    let code: String
    let skyline_background_url: String
    let map_image_url: String
    let landscape_background_url: String
    let state_seal_url: String
}

extension USAData {
    
    static func getUSAData() -> [USAData] {
        var arr = [USAData]()
        
        guard let fileURL = Bundle.main.url(forResource: "usa", withExtension: "json") else {
            fatalError()
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let allData = try JSONDecoder().decode([USAData].self, from: data)
            arr = allData
        } catch {
            fatalError("\(error)")
        }
        return arr
    }
    
}
