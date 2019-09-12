//
//  BusinessDetailsCoordinator.swift
//  Business_Search
//
//  Created by admin on 7/22/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

class BusinessDetailsCoordinator: Coordinator, OpenInSafariType, OpenAppleMapType, OpenPhoneType {
    private let business: Business
    private let dataController: DataController

    init(dataController: DataController, router: RouterType, business: Business) {
        self.dataController = dataController
        self.business = business
        super.init(router: router)
    }
    
    func start(parent: Coordinator){
        let newBusinessViewModel = BusinessDetailsViewModel(business: business)
        let newFavoriteViewModel = FavoritesViewModel(dataController: dataController)
        let newView = BusinessDetailsView()
        newView.viewModel = newBusinessViewModel
        let newController = BusinessDetailsController()
        newController.viewObject = newView
        newController.businessViewModel = newBusinessViewModel
        newController.favoriteViewModel = newFavoriteViewModel
        newController.coordinator = self
        router.push(newController, animated: true) {[weak self, weak parent] in
            parent?.removeChild(self)
            print("-2 popped -2")
        }
    }
    
    func loadPhoneCallScreen(number: String){
        let number = number.filter("0123456789".contains)
        if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func loadSafariBrowser(url: String){
        let verifiedURLStringFormatted = url._prependHTTPifNeeded()
        if let url = URL(string: verifiedURLStringFormatted) {
            UIApplication.shared.open(url)
            return
        }
    }
    
    func loadAppleMap(currentLocation: CLLocationCoordinate2D){
        let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude)))
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: business.latitude, longitude: business.longitude)))
        source.name = "Your Location"; destination.name = "Destination"
        MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}
