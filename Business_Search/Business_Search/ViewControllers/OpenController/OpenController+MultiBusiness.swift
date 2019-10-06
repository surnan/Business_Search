//
//  OpenController+MultiBusiness.swift
//  Business_Search
//
//  Created by admin on 10/5/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension OpenController {

    func duplicateBusinessAlertController(business: Business, businesses: [Business]){
        //Assuming that Business array count > 1
        let name = businesses.first?.name ?? ""
        let nextStepAlertController = UIAlertController(title: "Multiple Locations", message: "Would you like to load all \(name) in the area?", preferredStyle: .alert)
        
        
        let actionAll = UIAlertAction(title: "Show all \(name)", style: .default) { [weak self] (_) in
            self?.coordinator?.loadTabController(businesses: businesses, categoryName: name)
        }

        let actionOne = UIAlertAction(title: "Show only selected location", style: .default) { [weak self] (_) in
            self?.coordinator?.loadBusinessDetails(currentBusiness: business)
        }
        nextStepAlertController.addAction(actionAll)
        nextStepAlertController.addAction(actionOne)
        present(nextStepAlertController, animated: true)
    }
    
}
