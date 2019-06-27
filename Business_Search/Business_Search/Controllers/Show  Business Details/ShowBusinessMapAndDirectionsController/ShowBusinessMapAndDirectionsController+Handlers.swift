//
//  ShowBusinessMapAndDirectionsController+Handlers.swift
//  Business_Search
//
//  Created by admin on 6/26/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

extension ShowBusinessMapAndDirectionsController {
//    @objc func handleNextTable(){
//        print("")
//        let newVC = ShowBusinessRouteTableViewController()
//        newVC.steps = _steps
//        navigationController?.pushViewController(newVC, animated: true)
//    }
    
    @objc func handleDirectionSegmentControl(_ sender: UISegmentedControl){
        //transport = MKDirectionsTransportType.automobile
        switch sender.selectedSegmentIndex {
        case 0:     transport = MKDirectionsTransportType.walking
        case 1:     transport = MKDirectionsTransportType.automobile
        case 2:     getTransitDirections()  //transport = MKDirectionsTransportType.transit
        default:    print("Illegal index selected in Segment Controller")
        }
        getDirections()
    }
}