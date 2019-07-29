//
//  OpeningController+TableView.swift
//  Business_Search
//
//  Created by admin on 5/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


//NOTHING LABEL
extension SearchTableController{
    func undoBlur() {
        removeDarkScreenBlur()
        navigationController?.setNavigationBarHidden(false, animated: true)        
        
        doesLocationEntityExist = false
        readOrCreateLocation()
        animateResultsAreFilteredLabel()
    }
    
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
    
    func ShowNothingLabelIfNoResults(group: Int){
        switch group {
        case TableIndex.business.rawValue:
            if tableDataSource.fetchBusinessController?.fetchedObjects?.count == 0 && searchController.isActive && !searchBarIsEmpty(){
                viewObject.showNothingFoundView()
            } else {
                viewObject.hideNothingFoundView()
            }
        case TableIndex.category.rawValue:
            if tableDataSource.fetchCategoryNames?.count == 0 && searchController.isActive && !searchBarIsEmpty(){
                viewObject.showNothingFoundView()
            } else {
                viewObject.hideNothingFoundView()
            }
        default:
            print("ShowNothingLabelIfNoResults --> is very unhappy")
        }
    }
}


