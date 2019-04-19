//
//  YelpClient.swift
//  Business_Search
//
//  Created by admin on 4/14/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class Yelp{
    private enum Endpoints {  //+1
        static let base = "https://api.yelp.com/v3"
//                static let base = "https://api.yelp.com/v33"    //purposely forced error
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
    
    
    class func getAutoInputResults(text: String, latitude: Double, longitude: Double, completion: @escaping (Result<AutoCompleteResponse, NetworkError>)-> Void)-> URLSessionDataTask{
        let url = Endpoints.autocomplete(text, latitude, longitude).url
        let task = taskForYelpGetRequest(url: url, decoder: AutoCompleteResponse.self, errorDecoder: YelpAPIErrorResponse.self) { (result) in
            switch result {
            case .failure(let error):
                return completion(.failure(error))
            case .success(let answer):
                return completion(.success(answer))
            }
        }
        return task
    }
    
    class private func taskForYelpGetRequest<Decoder: Decodable, ErrorDecoder: Decodable>(url: URL, decoder: Decoder.Type, errorDecoder: ErrorDecoder.Type, completion: @escaping (Result<Decoder, NetworkError>) -> Void) -> URLSessionDataTask{
        var request = URLRequest(url: url)
//        request.setValue("Bearer \(API_Key)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request){ (data, resp, err) in
            
            //Need to handle here because response doesn't escape via completion handler
            if let respError = checkYelpStatusCodeForError(response: resp) {
                switch respError {
                case YelpAPIError.FIELD_REQUIRED: print("--> Yelp Error: 'Field Required' or 'Validation Error'")
                case YelpAPIError.UNAUTHORIZED: print("--> Yelp Error: 'Unauthorized'")
                case YelpAPIError.INTERNAL_SERVER_ERROR: print("--> Yelp Error: 'Internal Server Error'")
                default: print("--> Yelp Error: Undefined'")
                }
            }
            
            if let error = err {
                switch error._code {
                case -1001: completion(.failure(.networkTimeOut))
                case -1200: completion(.failure(.networkConnectionGoodButUnableToConnect))
                default: completion(.failure(.connectSuccesfulDownloadDataFail))
                }
                return
            }
            
            guard let dataObject =  data else {
                DispatchQueue.main.async {
                    completion(.failure(.noDataNoError))
                }
                return
            }
            
            do {
                let dataDecoded = try JSONDecoder().decode(decoder.self, from: dataObject)
                DispatchQueue.main.async {
                    completion(.success(dataDecoded))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.unableToDecode))
                }
            }
            
            do {
                let yelpErrorDecoded = try JSONDecoder().decode(YelpAPIErrorResponse.self, from: dataObject)
                print("yelpErrorDecoded: \n\(yelpErrorDecoded)")
                DispatchQueue.main.async {
                    completion(.failure(.yelpErrorDecoded))
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
    
    class private func checkYelpStatusCodeForError(response: URLResponse?)-> YelpAPIError?{
        let httpResponse = response as! HTTPURLResponse
        switch httpResponse.statusCode {
        case 200: return nil
        case 400: return YelpAPIError.FIELD_REQUIRED
        case 401: return YelpAPIError.UNAUTHORIZED
        case 500: return YelpAPIError.INTERNAL_SERVER_ERROR
        default: return YelpAPIError.UNKNOWN_ERROR
        }
    }
}

