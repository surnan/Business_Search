//
//  OpenView.swift
//  Business_Search
//
//  Created by admin on 7/29/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class OpenView {
    var viewModel: BusinessViewModel?
    
    let redView: UIView = {
        let myView = UIView()
        myView.backgroundColor = UIColor.lightRed
        myView.translatesAutoresizingMaskIntoConstraints = false
        return myView
    }()
    
    let nothingFoundView: GenericAttributedTextLabel = {
        let myView = GenericAttributedTextLabel(text: "No matches found", attributes: greenHelvetica_30_greyStroke)
        myView.alpha = 0
        myView.isUserInteractionEnabled = false
        return myView
    }()
    
    var blurredEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurredEffectView
    }()
    
    func showNothingFoundView(){
        UIView.animate(withDuration: 1.0) {[unowned self] in
            self.nothingFoundView.alpha = 1
        }
    }
    
    let resultsAreFilteredLabel = GenericLabel(text: "Partial results due to filter options...",
                                               size: 16,
                                               backgroundColor: UIColor.black)
    
    func hideNothingFoundView(){nothingFoundView.alpha = 0}
    
}
