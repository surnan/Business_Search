//
//  OpeningController+Filter.swift
//  Business_Search
//
//  Created by admin on 6/3/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

extension OpeningController {
    @objc func handleFilter(){
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.addSubview(blurredEffectView2)
        
        let newVC = FilterController()
        newVC.modalPresentationStyle = .overFullScreen
        newVC.delegate = self
        
        present(newVC, animated: true)
        
        
        
    }
}

