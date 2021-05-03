//
//  APIClient.swift
//  Covid-Data
//
//  Created by Tsering Lama on 12/15/20.
//

import Foundation
import Combine

enum ApiError: Error {
    case badURL(String)
    case networkError(Error)
    case decodingError(Error)
}

class APIClient {
        
    public func fetchAllContinents() -> AnyPublisher<[AllContientData], Error> {
       let endpoint = "https://corona.lmao.ninja/v2/continents?yesterday=true&sort="
        
       let url = URL(string: endpoint)!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [AllContientData].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    public func dataForFlag() -> AnyPublisher<[AllCountries],Error> {
        
        let endpoint = "https://corona.lmao.ninja/v2/countries?yesterday=true&sort="
        
        let url = URL(string: endpoint)!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [AllCountries].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    public func getAllCaseData() -> AnyPublisher<[AllCaseData], Error> {
        
        let endpoint = "https://corona.lmao.ninja/v2/historical?lastdays=30"
        
        let url = URL(string: endpoint)!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [AllCaseData].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    public func getACountry(country: String) -> AnyPublisher<CountryData, Error> {
        
        let noSpaceCountry = country.replacingOccurrences(of: " ", with: "%20")
        
        let endpoint = "https://disease.sh/v3/covid-19/countries/\(noSpaceCountry)?strict=true"
        
        let url = URL(string: endpoint)!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .receive(on: DispatchQueue.main)
            .decode(type: CountryData.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
