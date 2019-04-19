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
        request.setValue("Bearer \(API_Key)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request){ (data, resp, err) in
            _ = checkYelpStatusCodeForError(response: resp)  //'resp' not in completion handler.  Check now.
            
            if let error = err {
                switch error._code {
                case -1001: return completion(.failure(.networkTimeOut))
                case -1200: return completion(.failure(.networkConnectionGoodButUnableToConnect))
                default: return completion(.failure(.connectSuccesfulDownloadDataFail))
                }
            }
            
            guard let dataObject =  data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData_noError))
                }
                return
            }
            
            do {
                let dataDecoded = try JSONDecoder().decode(decoder.self, from: dataObject)
                DispatchQueue.main.async {
                    completion(.success(dataDecoded))
                }
            } catch let decodeError {
                do {
                    let yelpErrorDecoded = try JSONDecoder().decode(YelpAPIErrorResponse.self, from: dataObject)
                    print("\nYelp Error Decoded: \n\(yelpErrorDecoded)")
                    DispatchQueue.main.async {
                        completion(.failure(.yelpErrorDecoded))
                    }
                } catch {
                    print("\nDecoding Error: \n\(decodeError)")
                    DispatchQueue.main.async {
                        completion(.failure(.unableToDecode))
                    }
                }
            }
        }
        task.resume()
        return task
    }
    
    
    class private func checkYelpStatusCodeForError(response: URLResponse?)-> YelpAPIError?{
        
        guard let verifiedResponse = response else {return nil}
        
        let httpResponse = verifiedResponse as! HTTPURLResponse
        switch httpResponse.statusCode {
        case 200: return nil
        case 400: print("--> Yelp Error: 'Field Required' or 'Validation Error'"); return YelpAPIError.FIELD_REQUIRED
        case 401: print("--> Yelp Error: 'Field Required' or 'Validation Error'"); return YelpAPIError.UNAUTHORIZED
        case 500: print("--> Yelp Error: 'Internal Server Error'"); return YelpAPIError.INTERNAL_SERVER_ERROR
        default: print("--> Yelp Error: 'Undefined Error'"); return YelpAPIError.UNKNOWN_ERROR
        }
    }
}
