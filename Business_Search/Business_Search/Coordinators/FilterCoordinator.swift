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
    
    init(unblurProtocol: UnBlurViewType, router: RouterType) {
        self.unblurProtocol = unblurProtocol
        super.init(router: router)
    }
    
    
    func start(parent: Coordinator){
        let newViewModel    = FilterViewModel() //SettingsViewModel()
        let newViewObject   = FilterView()      //SettingsView()
        
        newViewObject.viewModel                 = newViewModel
        let newController                       = FilterController()
        newController.viewObject                = newViewObject
        newController.viewModel                 = newViewModel
        newController.delegate                  = unblurProtocol
        newController.coordinator               = self
        newController.modalPresentationStyle    = .overFullScreen
        
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
        router.present(newController, animated: true)
    }
}
