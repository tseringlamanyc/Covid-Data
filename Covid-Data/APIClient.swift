//
//  APIClient.swift
//  Covid-Data
//
//  Created by Tsering Lama on 12/15/20.
//

import Foundation

enum ApiError: Error {
    case badURL(String)
    case networkError(Error)
    case decodingError(Error)
}

class APIClient {
    
    public func fetchAllContinents(completion: @escaping(Result<[AllContientData],ApiError>) -> ()) {
        
        let endpoint = "https://corona.lmao.ninja/v2/continents?yesterday=true&sort="
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.badURL(endpoint)))
            return
        }
        
        let request = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completion(.failure(.networkError(error)))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("bad status code")
                return
            }
            
            if let data = data {
                
                do {
                    let allData = try JSONDecoder().decode([AllContientData].self, from: data)
                    completion(.success(allData))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
        dataTask.resume()
    }
}
