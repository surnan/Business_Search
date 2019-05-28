//
//  GoToMapTableController.swift
//  Business_Search
//
//  Created by admin on 5/27/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class GoToMapTableController: UITableViewController {
    var steps = [MKRoute.Step]() {
        didSet {
            steps.removeFirst()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return steps.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let step = steps[indexPath.row]
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.row + 1): \(step.instructions) .. \(step.distance.toMiles())"
        return cell
    }
}

extension CLLocationDistance {
    func toMiles() -> String {
        
        let feet = self * 3.2808
        let miles = (self) * 0.0006213712
        print("feet = \(feet) ... miles = \(miles)")
        
        if feet < 125 {
            let answer = String(Int(feet)) + " feet"
            return answer
        } else {
            let answer = (miles*100).rounded()/100
            let answerString = String(answer)
            return "\(answerString) miles"
        }
    }
}
