//
//  OpeningModel.swift
//  Business_Search
//
//  Created by admin on 7/4/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class OpeningModel {
    
    
    
    let nothingFoundView: GenericAttributedTextLabel = {
        let myView = GenericAttributedTextLabel(text: "No matches found", attributes: greenHelvetica_30_greyStroke)
        myView.alpha = 0
        myView.isUserInteractionEnabled = false
        return myView
    }()
    
    
    func hideNothingFoundView(){
        nothingFoundView.alpha = 0
    }
    
    func showNothingFoundView(){
        UIView.animate(withDuration: 1.0) {[unowned self] in
            self.nothingFoundView.alpha = 1
        }
    }
}


