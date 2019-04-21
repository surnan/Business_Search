//
//  YelpClient.swift
//  Business_Search
//
//  Created by admin on 4/14/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import CoreData

//https://api.yelp.com/v3/businesses/search?categories=pizza&latitude=37.786882&longitude=-122.399972&radius=500&limit=2
//https://api.yelp.com/v3/autocomplete?text=del&latitude=37.786942&longitude=-122.399643


class Yelp{
    private enum Endpoints {  //+1
        static let base = "https://api.yelp.com/v3"
        case autocomplete(String, Double, Double)
        case searchForBusinesses(String, Double, Double)
        case loadUpBusinesses(Double, Double)
        var toString: String {
            switch  self {
            case .autocomplete(let inputString, let latitude, let longitude):    return Endpoints.base
                + "/autocomplete?text=\(inputString)"
                + "&limit=\(limit)"
                + "&latitude=\(latitude)"
                + "&longitude=\(longitude)"
                + "&radius\(radius)"
            case .searchForBusinesses(let inputString, let latitude, let longitude):      return Endpoints.base
                + "/businesses"
                + "/search?categories=\(inputString)"
                + "&limit=\(limit)"
                + "&latitude=\(latitude)"
                + "&longitude=\(longitude)"
                + "&radius\(radius)"
            case .loadUpBusinesses(let latitude, let longitude):    return Endpoints.base
                + "/businesses"
                + "/search?latitude=\(latitude)"
                + "&longitude=\(longitude)"
                + "&radius=\(radius)"
                + "&limit=\(limit)"
                // +  "&offset= "
            }
        }
        var url: URL {
            let tempString = toString.replacingOccurrences(of: " ", with: "%20")
            return URL(string: tempString)!
        }
    } //-1
    
    
    
    class func getAutoInputResults(text: String, latitude: Double, longitude: Double, completion: @escaping (Result<YelpAutoCompleteResponse, NetworkError>)-> Void)-> URLSessionDataTask{
        let url = Endpoints.autocomplete(text, latitude, longitude).url
        print("url = \(url)")
        let task = taskForYelpGetRequest(url: url, decoder: YelpAutoCompleteResponse.self, errorDecoder: YelpAPIErrorResponse.self) { (result) in
            switch result {
            case .failure(let error):
                return completion(.failure(error))
            case .success(let answer):
                return completion(.success(answer))
            }
        }
        return task
    }
    
    
    class func getNearbyBusinesses(category: String, latitude: Double, longitude: Double, completion: @escaping (Result<YelpBusinessResponse, NetworkError>)-> Void)-> URLSessionDataTask{
        let url = Endpoints.searchForBusinesses(category, latitude, longitude).url
        let task = taskForYelpGetRequest(url: url, decoder: YelpBusinessResponse.self, errorDecoder: YelpAPIErrorResponse.self) { (result) in
            switch result {
            case .failure(let error):
                return completion(.failure(error))
            case .success(let answer):
                return completion(.success(answer))
            }
        }
        return task
    }
    
    
    
    class func loadUpBusinesses(locationID: NSManagedObjectID, latitude: Double, longitude: Double, completion: @escaping (NSManagedObjectID, Result<YelpBusinessResponse, NetworkError>)-> Void)-> URLSessionDataTask{
        let url = Endpoints.loadUpBusinesses(latitude, longitude).url
        let task = taskForYelpGetRequest(url: url, decoder: YelpBusinessResponse.self, errorDecoder: YelpAPIErrorResponse.self) { (result) in
            switch result {
            case .failure(let error):
                return completion(locationID, .failure(error))
            case .success(let answer):
                return completion(locationID, .success(answer))
            }
        }
        return task
    }
    
    
    class private func taskForYelpGetRequest<Decoder: Decodable, ErrorDecoder: Decodable>(url: URL, decoder: Decoder.Type, errorDecoder: ErrorDecoder.Type, completion: @escaping (Result<Decoder, NetworkError>) -> Void) -> URLSessionDataTask{
        var request = URLRequest(url: url)
        request.setValue("Bearer \(API_Key)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request){ (data, resp, err) in
            _ = checkYelpReturnedStatusCodes(response: resp)  //'resp' not in completion handler.  Check now.
            
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
    
    
   
    
    class private func checkYelpReturnedStatusCodes(response: URLResponse?)-> YelpAPIError?{
        guard let verifiedResponse = response else {return nil}
        let httpResponse = verifiedResponse as! HTTPURLResponse
        
        print("Number of Yelp Calls left today ==> \(String(describing: httpResponse.allHeaderFields["ratelimit-remaining"]))")
        
        switch httpResponse.statusCode {
        case 200: return nil
        case 400: print("--> Yelp Error: 'Field Required' or 'Validation Error'"); return YelpAPIError.FIELD_REQUIRED
        case 401: print("--> Yelp Error: 'Field Required' or 'Validation Error'"); return YelpAPIError.UNAUTHORIZED
        case 500: print("--> Yelp Error: 'Internal Server Error'"); return YelpAPIError.INTERNAL_SERVER_ERROR
        default: print("--> Yelp Error: 'Undefined Error'"); return YelpAPIError.UNKNOWN_ERROR
        }
    }
}
