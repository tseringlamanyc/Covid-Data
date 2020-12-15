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
