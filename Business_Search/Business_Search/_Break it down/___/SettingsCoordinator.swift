//
//  SettingsCoordinator.swift
//  Business_Search
//
//  Created by admin on 7/21/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import MapKit



class SettingsCoordinator: Coordinator {
    private let dataController: DataController
    private var maximumSliderValue: Int?
    var getMaximumSliderValue: Int? {return maximumSliderValue}
    let unblurProtocol: UnBlurViewProtocol
    
    init(unblurProtocol: UnBlurViewProtocol, dataController: DataController, router: RouterType) {
        self.unblurProtocol = unblurProtocol
        self.dataController = dataController
        super.init(router: router)
    }
    
    init(unblurProtocol: UnBlurViewProtocol, dataController: DataController, router: RouterType, maximumSliderValue: Int? = nil) {
        self.unblurProtocol = unblurProtocol
        self.dataController = dataController
        self.maximumSliderValue = maximumSliderValue
        super.init(router: router)
    }
        
    func start(parent: Coordinator){
        let vc = SettingsController()
        vc.dataController           = dataController
        vc.delegate                 = unblurProtocol
        vc.coordinator              = self
        vc.modalPresentationStyle   = .overFullScreen
        vc.dismissController = {[weak self] in
            self?.router.dismissModule(animated: true, completion: {
                self?.unblurProtocol.undoBlur()
            })
        }
        router.present(vc, animated: true)
    }
}
