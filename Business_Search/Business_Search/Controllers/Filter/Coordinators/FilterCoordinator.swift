//
//  FilterCoordinator.swift
//  Business_Search
//
//  Created by admin on 7/22/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


class FilterCoordinator: Coordinator {
    let unblurProtocol: UnBlurViewProtocol
    
    init(unblurProtocol: UnBlurViewProtocol, router: RouterType) {
        self.unblurProtocol = unblurProtocol
        super.init(router: router)
    }
    
    
    func start(parent: Coordinator){
        let vc = FilterController()
        vc.delegate                 = unblurProtocol
        vc.coordinator              = self
        vc.modalPresentationStyle   = .overFullScreen
        
        vc.dismissController = {[weak self] in
            self?.router.dismissModule(animated: true, completion: {
                self?.unblurProtocol.undoBlur()
            })
        }
        
        vc.saveDismissController = {[weak self] in
            self?.router.dismissModule(animated: true){
                UserAppliedFilter.shared.load()
                self?.unblurProtocol.undoBlur()
                _ = UserAppliedFilter.shared.getBusinessPredicate()
            }
        }
        
        router.present(vc, animated: true)
    }
}
