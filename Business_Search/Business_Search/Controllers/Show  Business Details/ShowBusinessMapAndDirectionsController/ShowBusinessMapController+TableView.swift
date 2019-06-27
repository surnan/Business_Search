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

extension ShowBusinessMapAndDirectionsController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _steps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let step = _steps[indexPath.row]
        let cell = UITableViewCell()
        cell.backgroundColor = .black
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = "\(indexPath.row + 1): \(step.distance.toMiles()) .. \(step.instructions)"
        return cell
    }
}
