//
//  OpenCoordinator.swift
//  Business_Search
//
//  Created by admin on 7/21/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import MapKit

class OpenCoordinator: Coordinator {
    let dataController: DataController
    let location : CLLocation
    
    init(dataController: DataController, router: RouterType, location: CLLocation){
        self.dataController = dataController
        self.location = location
        super.init(router: router)
    }
    
    func start(parent: Coordinator){
        let coordinate = location.coordinate
        let vc = OpeningController()
        vc.dataController = dataController
        vc.latitude = coordinate.latitude
        vc.longitude = coordinate.longitude
        vc.coordinator = self
        router.push(vc, animated: true) {[weak self, weak parent] in
            parent?.removeChild(self)
            print("-2 popped -2")
        }
    }
}

class SettingsCoordinator: Coordinator {
    let unblurProtocol: UnBlurViewProtocol
    let dataController: DataController
    
    init(unblurProtocol: UnBlurViewProtocol, dataController: DataController, router: RouterType) {
        self.unblurProtocol = unblurProtocol
        self.dataController = dataController
        super.init(router: router)
    }
    
    func start(parent: Coordinator){
        let vc = SettingsController()
        vc.dataController           = dataController
        vc.delegate                 = unblurProtocol
        vc.coordinator              = self
        vc.modalPresentationStyle   = .overFullScreen
        router.present(vc, animated: true)
    }
}
