//
//  OpenController+UI.swift
//  Business_Search
//
//  Created by admin on 7/30/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension OpenController {
    //    func undoBlur() {
    //        removeDarkScreenBlur()
    //        navigationController?.setNavigationBarHidden(false, animated: true)
    //
    //        doesLocationEntityExist = false
    //        readOrCreateLocation()
    //        animateResultsAreFilteredLabel()
    //    }
    
    func animateResultsAreFilteredLabel(){
        if !UserAppliedFilter.shared.isFilterOn {return}
        view.addSubview(viewObject.resultsAreFilteredLabel)
        let safe = view.safeAreaLayoutGuide
        viewObject.resultsAreFilteredLabel.anchor(top: safe.topAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor)
        viewObject.resultsAreFilteredLabel.alpha = 1
        UIView.animate(withDuration: 1.5, animations: {
            self.viewObject.resultsAreFilteredLabel.alpha = 0
        }) { (_) in
            self.viewObject.resultsAreFilteredLabel.removeFromSuperview()
        }
    }
    
    func showNothingLabel(tableEmpty: Bool){
        if tableEmpty && searchController.isActive && !searchBarIsEmpty(){
            viewObject.showNothingFoundView()
        } else {
            viewObject.hideNothingFoundView()
        }
    }
}
