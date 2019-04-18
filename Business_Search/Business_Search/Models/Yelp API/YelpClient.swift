//
//  YelpClient.swift
//  Business_Search
//
//  Created by admin on 4/14/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation


enum NetworkError: Error {
    case badURL
    case urlSessionDataTaskGetError
    case unableToDecode
    case noDataNoError
}

class Yelp{
    enum Endpoints {  //+1
        static let base = "https://api.yelp.com/v3"
        case autocomplete(String, Double, Double)
        case businesses(String)
        var toString: String {
            switch  self {
            case .autocomplete(let inputString, let latitude, let longitude):    return Endpoints.base
                + "/autocomplete?text=\(inputString)"
                + "&fetch=\(fetchLimit)"
                + "&latitude=\(latitude)"
                + "&longitude=\(longitude)"
            case .businesses(let inputString):      return Endpoints.base
                + "/search?categories=\(inputString)"
                + "&fetch=\(fetchLimit)"
            }
        }
        var url: URL {
            return URL(string: toString)!
        }
    } //-1
    
    class private func taskForGetRequest<Decoder: Decodable>(url: URL, decoder: Decoder.Type, completion: @escaping (Result<Decoder, NetworkError>) -> Void) -> URLSessionDataTask{
        var request = URLRequest(url: url)
        request.setValue("Bearer \(API_Key)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request){ (data, resp, err) in
            if err != nil {
                DispatchQueue.main.async {
                    completion(.failure(.urlSessionDataTaskGetError))
                }
            }
            
            guard let dataObject =  data else {
                print("taskForGetRequest() - There's no data")
                DispatchQueue.main.async {
                    completion(.failure(.noDataNoError))
                }
                return
            }
            
            do {
                let answer = try JSONDecoder().decode(decoder.self, from: dataObject)
                DispatchQueue.main.async {
                    completion(.success(answer))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.unableToDecode))
                }
            }
        }
        task.resume()
        return task
    }

    
    class func getAutoInputResults(text: String, latitude: Double, longitude: Double, completion: @escaping (Result<AutoCompleteResponse, NetworkError>)-> Void)-> URLSessionDataTask{
        let url = Endpoints.autocomplete(text, latitude, longitude).url
        let task = taskForGetRequest(url: url, decoder: AutoCompleteResponse.self) { (result) in
            switch result {
            case .failure(let error):
                print("Error (localized): \(error.localizedDescription)\n\nError: \(error)")
                return completion(.failure(error))
            case .success(let answer):
                return completion(.success(answer))
            }
        }
        return task
    }
}

