//
//  OpeningController+TableView.swift
//  Business_Search
//
//  Created by admin on 5/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData


extension OpeningController{

    private func showNothingFoundView(){
        UIView.animate(withDuration: 1.0) {[unowned self] in
            self.model.nothingFoundView.alpha = 1
        }
    }
    
    private func hideNothingFoundView(){
        model.nothingFoundView.alpha = 0
    }
    
    
    func ShowNothingLabelIfNoResults(group: Int){
        switch group {
        case TableIndex.business.rawValue:
            if tableDataSource.fetchBusinessController?.fetchedObjects?.count == 0 && searchController.isActive && !searchBarIsEmpty(){
                showNothingFoundView()
            } else {
                hideNothingFoundView()
            }
        case TableIndex.category.rawValue:
            if tableDataSource.fetchCategoryNames?.count == 0 && searchController.isActive && !searchBarIsEmpty(){
                showNothingFoundView()
            } else {
                hideNothingFoundView()
            }
        default:
            print("ShowNothingLabelIfNoResults --> is very unhappy")
        }
    }
}


