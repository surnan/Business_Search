//
//  FilterCoordinator.swift
//  Business_Search
//
//  Created by admin on 7/22/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


class FilterCoordinator: Coordinator {
    private let unblurProtocol: UnBlurViewType
    private var parent: Coordinator!
    private let dataController: DataController
    
    init(unblurProtocol: UnBlurViewType, dataController: DataController, router: RouterType) {
        self.unblurProtocol = unblurProtocol
        self.dataController = dataController
        super.init(router: router)
    }
    
    
    func start(parent: Coordinator, animationType: Bool = true){
        
        
        
        let newViewModel    = FilterViewModel() //SettingsViewModel()
        let newViewObject   = FilterView()      //SettingsView()
        
        newViewObject.viewModel                 = newViewModel
        let newController                       = FilterController()
        newController.viewObject                = newViewObject
        newController.viewModel                 = newViewModel
        newController.delegate                  = unblurProtocol
        newController.coordinator               = self
        newController.modalPresentationStyle    = .overFullScreen
        
        
        /////
        self.parent = parent
        ////
        
        
        newController.dismissController = {[weak self] in
            self?.router.dismissModule(animated: true, completion: {
                self?.unblurProtocol.undoBlur()
            })
        }
        
        newController.saveDismissController = {[weak self] in
            self?.router.dismissModule(animated: true){
                UserAppliedFilter.shared.load()
                self?.unblurProtocol.undoBlur()
                _ = UserAppliedFilter.shared.getBusinessPredicate()
            }
        }
        
        newController.dismissCleanly = {[weak self] in
            self?.router.dismissModule(animated: true, completion: {
                //self?.unblurProtocol.undoBlur()
                self?.loadSettingsController()
            })
        }
        router.present(newController, animated: true)
    }
    
    
    func loadSettingsController(){
        
//        let coord = SettingsCoordinator(unblurProtocol: unblurProtocol, dataController: <#T##DataController#>, router: router)
//        let coord2 = SettingsCoordinator(unblurProtocol: unblurProtocol, dataController: <#T##DataController#>, router: router, maximumSliderValue: <#T##Int?#>)
//
//        coord.start(parent: parent)
    }
    
}
