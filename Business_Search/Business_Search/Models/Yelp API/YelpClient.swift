//
//  YelpClient.swift
//  Business_Search
//
//  Created by admin on 4/14/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
var fetchLimit = 50

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
    
    
    class func getAutoInputResults(text: String, latitude: Double, longitude: Double)-> URLSessionDataTask{
        let url = Endpoints.autocomplete(text, latitude, longitude).url
        
        let task = taskForGetRequest(url: url, decoder: AutoCompleteResponse.self) { (data, err) in
            if let error = err {
                print("Error trying to decode data \n\n\(error.localizedDescription)\n\n\(error)")
            }
            if let data = data {
                print("\(data)")
            }
        }
        return task
    }
    
    
    class private func taskForGetRequest<Decoder: Decodable>(url: URL, decoder: Decoder.Type, completion: @escaping (Decoder?, Error?)-> Void) -> URLSessionDataTask{
        var request = URLRequest(url: url)
        request.setValue("Bearer \(API_Key)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request){ (data, resp, err) in
            if let err = err {print("error:\n\(err)")}
            guard let dataObject =  data else {print("There's no data"); return}
            
            do {
                let answer = try JSONDecoder().decode(AutoCompleteResponse.self, from: dataObject)
                print("=========\n\(answer)")
            } catch {
                print("URL = \(url)")
                print("failed: \n\n\(error.localizedDescription)\n=============\n\(error)")
            }
        }
        task.resume()
        return task
    }
}















/*
 struct SearchLocation {
 private static var _address: String?
 private static var _latitude: Double?
 private static var _longitude: Double?
 
 static func setAddress(address: String){
 self._address = address
 self._longitude = nil
 self._latitude = nil
 }
 
 static func setAddress(lat: Double, lon: Double){
 self._address = nil
 self._latitude = lat
 self._longitude = lon
 }
 
 static func getAddress()-> String {
 if let address = _address {
 return "&\"\(address)\""
 }
 
 guard let lat = _latitude, let lon = _longitude else {return ""}
 return "&latitude=\(lat)&longitude=\(lon)"
 }
 }
 */
