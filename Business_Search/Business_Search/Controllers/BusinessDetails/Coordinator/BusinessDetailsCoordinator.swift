//
//  BusinessDetailsCoordinator.swift
//  Business_Search
//
//  Created by admin on 7/22/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

class BusinessDetailsCoordinator: Coordinator, OpenInSafariType, OpenAppleMapType {
    let business: Business
    
    init(router: RouterType, business: Business) {
        self.business = business
        super.init(router: router)
    }
    
    func start(parent: Coordinator){
        let newVC = BusinessDetailsController()
        newVC.business = business
        newVC.coordinator = self
        router.push(newVC, animated: true) {[weak self, weak parent] in
            parent?.removeChild(self)
            print("-2 popped -2")
        }
    }
    
    func handleOpenBrowser(urlString: String){
        let verifiedURLStringFormatted = urlString._prependHTTPifNeeded()
        if let url = URL(string: verifiedURLStringFormatted) {
            UIApplication.shared.open(url)
            return
        }
    }
    
    func handleMapItButton(currentLocation: CLLocationCoordinate2D){
        let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude)))
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: business.latitude, longitude: business.longitude)))
        source.name = "Your Location"; destination.name = "Destination"
        MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}


