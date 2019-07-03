//
//  OpeningController+TableView.swift
//  Business_Search
//
//  Created by admin on 5/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

extension OpeningController: UITableViewDelegate {
    
    //Tableview Row Actions
    func shareBusiness(business: Business){
        let prependText = UserDefaults.standard.object(forKey: AppConstants.greetingMessage.rawValue) as? String ?? "3 - This is the yelp page for what I'm looking at: "
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
        let prependText = UserDefaults.standard.object(forKey: AppConstants.greetingMessage.rawValue) as? String ?? "3 - This is the yelp page for what I'm looking at: "
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



    //Nothing Found Label
    
    private func showNothingFoundView(){
        UIView.animate(withDuration: 1.0) {[unowned self] in
            self.nothingFoundView.alpha = 1
        }
    }
    
    private func hideNothingFoundView(){
        nothingFoundView.alpha = 0
    }
    
    
    func ShowNothingLabelIfNoResults(group: Int){
        switch group {
        case TableIndex.business.rawValue:
            if model.fetchBusinessController?.fetchedObjects?.count == 0 && searchController.isActive && !searchBarIsEmpty(){
                showNothingFoundView()
            } else {
                hideNothingFoundView()
            }
        case TableIndex.category.rawValue:
            if model.fetchCategoryNames?.count == 0 && searchController.isActive && !searchBarIsEmpty(){
                showNothingFoundView()
            } else {
                hideNothingFoundView()
            }
        default:
            print("ShowNothingLabelIfNoResults --> is very unhappy")
        }
    }

    //NavigationController().push()
    
    func showBusinessInfo(currentBusiness: Business){
        let newVC = BusinessDetailsController()
        newVC.business = currentBusiness
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    
    func getBusinessesFromCategoryName(category: String)-> [Business]{
        //This array is not NOT shown in this tableView.
        
        //'BARS' includes hits from other groups with "bar"
        //selectedCategoryPredicate = NSPredicate(format: "title CONTAINS[cd] %@", argumentArray: [category])
        
        //'MATCHES' is confused when string contains parenthesis.  Such as "American (New)"
        //selectedCategoryPredicate = NSPredicate(format: "title MATCHES[cd] %@", argumentArray: [category])
        
        model.selectedCategoryPredicate = NSPredicate(format: "title BEGINSWITH[cd] %@", argumentArray: [category])
        model.fetchCategoriesController = nil
        var businessArray = [Business]()    //Pushed into next ViewController
        model.fetchCategoriesController?.fetchedObjects?.forEach{businessArray.append($0.business!)}
        businessArray = businessArray.filter{
            return $0.parentLocation?.latitude == latitude &&
                $0.parentLocation?.longitude == longitude
        }
        let businesses = UserAppliedFilter.shared.getFilteredBusinessArray(businessArray: businessArray)
        return businesses
    }
    
    func listBusinesses(category: String){
        let newVC = MyTabController()
        let items = getBusinessesFromCategoryName(category: category)
        newVC.businesses = items
        newVC.categoryName = category
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    //Manipulates another Core Data Entity
    func deleteFavorite(business: Business){
        //lazy var predicateBusinessLatitude = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Business.parentLocation.latitude), latitude!])
        model.fetchFavoritePredicate = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Favorites.id), business.id!])
        model.fetchFavoritesController = nil
        model.fetchFavoritesController?.fetchedObjects?.forEach({ (item) in
            dataController.viewContext.delete(item)
            do {
                try dataController.viewContext.save()
            } catch {
                print(error)
                print(error.localizedDescription)
            }
        })
    }
    
    func createFavoriteEntity(business: Business, context: NSManagedObjectContext){
        let newFavorite2 = Favorites(context: context)
        newFavorite2.id = business.id
        do {
            try context.save()
            print("createFavorite -- SAVE()")
        } catch {
            print("\nError saving newly created favorite - localized error: \n\(error.localizedDescription)")
            print("\n\nError saving newly created favorite - full error: \n\(error)")
        }
    }
}


