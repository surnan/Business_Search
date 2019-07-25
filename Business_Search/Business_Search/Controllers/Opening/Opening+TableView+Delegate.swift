//
//  OpeningController+Protocol.swift
//  Business_Search
//
//  Created by admin on 7/4/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


//These functions are called by TableView Delegate
extension SearchTableController: OpeningControllerProtocol, BusinessDetailsType{
    func loadBusinessDetails(currentBusiness: Business){coordinator?.loadBusinessDetails(currentBusiness: currentBusiness)}
    func updateBusinessIsFavorite(business: Business)->Bool{return business.isFavoriteChange(context: dataController.viewContext)}
    func reloadData(){model.tableView.reloadData()}
    
    //MARK:- ROW RIGHT-SIDE ACTIONS
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
            self.dismiss(animated: true, completion: nil)
        }
        present(activityVC, animated: true)
    }
    
    func pickRandomBusiness(businesses: [Business]){
        let prependText = UserDefaults.standard.object(forKey: AppConstants.greetingMessage.rawValue) as? String
            ?? "3 - This is the yelp page for what I'm looking at: "
        let items: [Any] = ["\(prependText) www.yelp.com"]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityVC.completionWithItemsHandler = {[unowned self](activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
        present(activityVC, animated: true)
    }
    
    //MARK:- Favorites
    func deleteFavorite(business: Business){
        tableDataSource.updateFavoritesPredicate(business: business)
        tableDataSource.fetchFavoritesController?.fetchedObjects?.forEach({ (item) in
            dataController.viewContext.delete(item)
            do {
                try dataController.viewContext.save()
            } catch {
                print(error)
                print(error.localizedDescription)
            }
        })
    }
    
    func createFavorite(business: Business){
        let context = dataController.viewContext
        let newFavorite2 = Favorites(context: context)
        newFavorite2.id = business.id
        do {
            try context.save()
        } catch {
            print("\nError saving newly created favorite - localized error: \n\(error.localizedDescription)")
            print("\n\nError saving newly created favorite - full error: \n\(error)")
        }
    }
    
    //MARK: - Row Action when Search Group = "Categories"
    func listBusinesses(category: String){
        let items = getBusinessesFromCategoryName(category: category)
        coordinator?.loadTabController(businesses: items, categoryName: category)
        
//        let newVC = MyTabController()
//        newVC.businesses = items
//        newVC.categoryName = category
//        navigationController?.pushViewController(newVC, animated: true)
    }
    
    func getBusinessesFromCategoryName(category: String)-> [Business]{  //NOT shown in this tableView.
        tableDataSource.updateCategoryPredicate(category: category)
        var businessArray = [Business]()    //Pushed into next ViewController
        tableDataSource.fetchCategoriesController?.fetchedObjects?.forEach{businessArray.append($0.business!)}
        businessArray = businessArray.filter{
            return $0.parentLocation?.latitude == latitude &&
                $0.parentLocation?.longitude == longitude
        }
        let businesses = UserAppliedFilter.shared.getFilteredBusinessArray(businessArray: businessArray)
        return businesses
    }
}
