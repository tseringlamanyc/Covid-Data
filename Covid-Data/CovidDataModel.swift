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
