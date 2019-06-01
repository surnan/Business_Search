//
//  GoToMapController+Extension.swift
//  Business_Search
//
//  Created by admin on 5/31/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

extension GoToMapController {
    
    
    func getTransitDirections(){
        let mapURL = URL(string: "https://maps.googleapis.com/maps/api/directions/json?&mode=transit&routes=transit&origin=40.7590+-73.9845&destination=40.7110241158536+-74.0124703624216&key=AIzaSyDGg9KrIhBikjHA--5OTYlRufyTfQl2N7w")!
        
        let task = URLSession.shared.dataTask(with: mapURL) { (data, resp, error) in
            guard let data = data else {return}
            let decoder = JSONDecoder()
            
            do {
                let jsonData = try decoder.decode(GoogleMapResponse.self, from: data)
                print("json data: \n \(jsonData)")
                print("")
            } catch {
                print("Error catching jsonData: \n\(error)")
            } 
        }
        task.resume()
    }
}



/*
 func getTransitDirections(){
 let mapURL = URL(string: "https://maps.googleapis.com/maps/api/directions/json?&mode=transit&routes=transit&origin=40.7590+-73.9845&destination=40.7110241158536+-74.0124703624216&key=AIzaSyDGg9KrIhBikjHA--5OTYlRufyTfQl2N7w")!
 
 let task = URLSession.shared.dataTask(with: mapURL) { (data, resp, error) in
 if let json = try? JSON(data: data!) {
 for item in json["status"].arrayValue {
 //for item in json["routes"]["legs"]["steps"]["html_instructions"].arrayValue {
 print("Item = \(item.stringValue)")
 }
 }
 }
 task.resume()
 }
 
 
 */
