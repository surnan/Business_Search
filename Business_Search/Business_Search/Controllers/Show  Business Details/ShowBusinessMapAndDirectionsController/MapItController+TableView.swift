//
//  ShowBusinessMapController+TableView.swift
//  Business_Search
//
//  Created by admin on 6/26/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

extension MapItController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return _steps.count
        return showGoogleMaps ? transitSteps[section].count - 1 : _steps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if showGoogleMaps {
            let cell = UITableViewCell()
            let myText = transitSteps[indexPath.section][indexPath.row + 1]
            cell.textLabel?.text = "\(indexPath) -> \(myText)"
            return cell
        }
        let step = _steps[indexPath.row]
        let cell = UITableViewCell()
        cell.backgroundColor = .black
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = "\(indexPath.row + 1): \(step.distance.toMiles()) .. \(step.instructions)"
        return cell
    }
    
    ////  NEW STUFF ////
    func numberOfSections(in tableView: UITableView) -> Int {
        return  showGoogleMaps ? transitSteps.count : 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return showGoogleMaps ? transitSteps[section].first : nil
    }
    
    
    
}
