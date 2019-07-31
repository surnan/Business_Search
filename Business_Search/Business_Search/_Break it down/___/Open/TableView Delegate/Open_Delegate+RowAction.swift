//
//  Open_Delegate+RowAction.swift
//  Business_Search
//
//  Created by admin on 7/30/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension Open_Delegate {
    //MARK:- ROW RIGHT-SIDE ACTIONS
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let actionBusiness = UITableViewRowAction(style: .normal, title: "SHARE") {[unowned self] (action, indexPath) in
            guard let currentBusiness = self.source.businessViewModel.fetchBusinessController?.object(at: indexPath) else {return}
            self.shareBusiness(business: currentBusiness)
        }
        actionBusiness.backgroundColor = .darkBlue
        let actionCategory = UITableViewRowAction(style: .normal, title: "RANDOM") {[unowned self] (action, indexPath) in
            let currentCategory = self.getCategoryName(at: indexPath.row)
            
            let items           = self.getBusinessesFromCategoryName(category: currentCategory)
            let modder          = items.count - 1
            let randomNumber    = Int.random(in: 0...modder)
            self.parent.coordinator?.loadBusinessDetails(currentBusiness: items[randomNumber])
        }
        actionBusiness.backgroundColor = .red
        actionCategory.backgroundColor = .blue
        return source.tableArrayType == TableIndex.category.rawValue ? [actionCategory] : [actionBusiness]
    }
    
    func getCategoryName(at index: Int) -> String {
        guard let categoryNames = source.categoryNameCountViewModel.fetchCategoryNames else {return ""}
        let categoryName = categoryNames[index]
        return categoryName
    }
    
    func shareBusiness(business: Business){
        let prependText = UserDefaults.standard.object(forKey: AppConstants.greetingMessage.rawValue) as? String
            ?? "Please check this link. \n"
        guard let temp = business.url else {return}
        let items: [Any] = ["\(prependText) \(temp)"]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityVC.completionWithItemsHandler = {[unowned self](activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                return
            }
            self.parent.dismiss(animated: true, completion: nil)
        }
        parent.present(activityVC, animated: true)
    }
}
