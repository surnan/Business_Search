//
//  GoToMapController+Extension.swift
//  Business_Search
//
//  Created by admin on 5/31/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

extension ShowBusinessMapController {
    
    func getTransitDirections(){
        let mapURL = URL(string: "https://maps.googleapis.com/maps/api/directions/json?&mode=transit&routes=transit&origin=40.7590+-73.9845&destination=40.7110241158536+-74.0124703624216&key=AIzaSyDGg9KrIhBikjHA--5OTYlRufyTfQl2N7w")!
        
        let task = URLSession.shared.dataTask(with: mapURL) { (data, resp, error) in
            guard let data = data else {return}
            let decoder = JSONDecoder()
            
            do {
                let jsonData = try decoder.decode(GoogleMapResponse.self, from: data)
                //print("json data: \n \(jsonData)")
                self.buildTransitMap(json: jsonData)
            } catch {
                print("Error catching jsonData: \n\(error)")
            }
        }
        task.resume()
    }
    
    
    func buildTransitMap(json: GoogleMapResponse){ //+1
        
        tableViewArrays = [[String]]()
        
        guard let allSteps = json.routes.first?.legs.first?.steps else {
            print("No Legs in JSON")
            return
        }
        
        for (index, currentStep) in allSteps.enumerated() {
            let htmlInstruction = "\(currentStep.html_instructions ?? "no html instructions found")"
            //print("html instructions = \(htmlInstruction)")
            tableViewArrays.append([htmlInstruction])
            
            if let moreSteps = currentStep.steps {
                for innerStep in moreSteps {
                    let innerStep = "\(innerStep.html_instructions ?? "No Inner Step found")"
                    //print("Inner Step: \(innerStep)")
                    tableViewArrays[index].append(innerStep)
                }
            }
            
            if let moreTransit = currentStep.transit_details {
                let moreTransit = "\(moreTransit.arrival_stop.name) with '\(moreTransit.line.short_name)'"
                //print("moreTransit: \(moreTransit)")
                tableViewArrays[index].append(moreTransit)
            }
        }
        
        DispatchQueue.main.async {
            let newVC = ShowBusinessTransitTableViewController()
            newVC.transitSteps = self.tableViewArrays
            self.navigationController?.pushViewController(newVC, animated: true)
        }
    } //-1
}
