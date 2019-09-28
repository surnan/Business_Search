//
//  Coordinator Protocols.swift
//  Business_Search
//
//  Created by admin on 7/16/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import MapKit

protocol PushOpen {
    func pushOpenCoordinator(userLocation: CLLocation)
}

protocol PushSearchByMap {
    func pushSearchByMapCoordinator(location: CLLocation)
}

protocol PushSearchByAddress {
    func pushSearchByAddressCoordinator(location: CLLocation)
}

protocol PresentSettings {
    func presentSettingsCoordinator(destination: UIViewController)
}

