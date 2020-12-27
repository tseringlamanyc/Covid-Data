//
//  CovidDataModel.swift
//  Covid-Data
//
//  Created by Tsering Lama on 12/15/20.
//

import Foundation

struct AllContientData: Decodable, Hashable {
    let updated, cases, todayCases, deaths: Int
    let todayDeaths, recovered, todayRecovered, active: Int
    let critical: Int
    let casesPerOneMillion, deathsPerOneMillion: Double
    let tests: Int
    let testsPerOneMillion: Double
    let population: Int
    let continent: String
    let activePerOneMillion, recoveredPerOneMillion, criticalPerOneMillion: Double
    let countries: [String]
}

struct CasesData: Decodable {
    let country: String
    let timeline: Timeline
}

struct Timeline: Decodable {
    let cases: [String: Int]
    let deaths: [String: Int]
    let recovered: [String: Int]
}


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
    let cases, deaths, recovered: [String: Int]
}

struct CountryInfo: Decodable, Hashable {
    let flag: String
}
