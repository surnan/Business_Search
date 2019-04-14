//
//  ViewController.swift
//  Business_Search
//
//  Created by admin on 4/14/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

class MapController: UITabBarController {
    var fullScreenMap = MKMapView()
    
    
    func setupUI(){
        [fullScreenMap].forEach{view.addSubview($0)}
        fullScreenMap.fillSafeSuperView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

