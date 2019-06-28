//
//  OpeningController+TableView.swift
//  Business_Search
//
//  Created by admin on 5/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

extension OpeningController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }

    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let actionBusiness = UITableViewRowAction(style: .normal, title: "SHARE") { (action, indexPath) in
            guard let currentBusiness = self.fetchBusinessController?.object(at: indexPath) else {return}
            self.shareBusiness(business: currentBusiness)
        }
        actionBusiness.backgroundColor = .darkBlue
    
    
        let actionCategory = UITableViewRowAction(style: .normal, title: "RANDOM") { (action, indexPath) in
            guard let currentCategory = self.fetchCategoryNames?[indexPath.row] else {return}
            let items = self.getBusinessesFromCategoryName(category: currentCategory)
            let modder = items.count - 1
            let randomNumber = Int.random(in: 0...modder)
            print(items[randomNumber].name ?? "")
            
            
            self.showBusinessInfo(currentBusiness: items[randomNumber])
            
        }
    
        actionBusiness.backgroundColor = .red
        actionCategory.backgroundColor = .blue
    
        if tableViewArrayType == TableIndex.category.rawValue {
            return [actionCategory]
        } else {
            return [actionBusiness]
        }
    }

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
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableViewArrayType == TableIndex.category.rawValue {return nil}
        let action = UIContextualAction(style: .normal, title: "Favorite") { [weak self] (action, view, myBool) in
            guard let self = self else {return}
            guard let currentBusiness = self.fetchBusinessController?.object(at: indexPath) else {return}
            let isFavorite = currentBusiness.isFavoriteChange(context: self.dataController.viewContext)
            myBool(true)    //Dismiss the leading swipe action
            tableView.reloadRows(at: [indexPath], with: .automatic)
            if isFavorite {
                self.createFavoriteEntity(business: currentBusiness, context: self.dataController.backGroundContext)
                self.fetchBusinessController = nil
                self.tableView.reloadData()
            } else {
                self.deleteFavorite(business: currentBusiness)
                self.fetchBusinessController = nil
                self.tableView.reloadData()
                //TODO: delete favorite
                print("currentBusiness.id --> \(currentBusiness.id!)")
                print("")
            }
        }
        guard let currentBusiness = self.fetchBusinessController?.object(at: indexPath) else {return nil}
        action.image = currentBusiness.isFavorite ?  #imageLiteral(resourceName: "cancel") : #imageLiteral(resourceName: "Favorite")
        action.backgroundColor =  currentBusiness.isFavorite ? .lightSteelBlue1 : .orange
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }

    
    func deleteFavorite(business: Business){
        //lazy var predicateBusinessLatitude = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Business.parentLocation.latitude), latitude!])
        fetchFavoritePredicate = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Favorites.id), business.id!])
        fetchFavoritesController = nil
        
        fetchFavoritesController?.fetchedObjects?.forEach({ (item) in
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableViewArrayType {
        case TableIndex.business.rawValue:
            let state = fetchBusinessController?.fetchedObjects?.count ?? 0
            ShowNothingLabelIfNoResults(group: tableViewArrayType)
            return state
        case TableIndex.category.rawValue:
            let state = fetchCategoryNames?.count ?? 0
            ShowNothingLabelIfNoResults(group: tableViewArrayType)
            return state
        default:
            print("numberOfRowsInSection --> WHOOOOOPS!!")
        }
        return TableIndex.business.rawValue
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableViewArrayType {
        case TableIndex.business.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: _businessCellID, for: indexPath) as! _BusinessCell
            cell.backgroundColor = colorArray[indexPath.row % colorArray.count]
            cell.currentBusiness = fetchBusinessController?.object(at: indexPath)
            return cell
        case TableIndex.category.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: categoryCellID, for: indexPath) as! CategoryCell
            cell.backgroundColor = colorArray[indexPath.row % colorArray.count]
            let currentCategoryName = fetchCategoryNames?[indexPath.row]
            let _fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
            let myPredicate = NSPredicate(format: "%K == %@", #keyPath(Category.title), currentCategoryName!)
            let filterControllerPredicate = UserAppliedFilter.shared.getCategoryPredicate()        //FilterController() & Singleton
            var tempPredicate = [myPredicate, predicateCategoryLatitude, predicateCategoryLongitude]
            filterControllerPredicate.forEach{tempPredicate.append($0)}
            _fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: tempPredicate)
            
            cell.name = currentCategoryName
            do {
                let count = try dataController.viewContext.count(for: _fetchRequest)
                cell.count = count
            } catch {
                cell.count = 0
                print("Failed to get Count inside cellForRowAt: \n\(error)")
            }
            return cell
        default:
            print("Something Bad HAPPENED inside cellForRowAt:")
            return UITableViewCell()
        }
    }
    
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
            if fetchBusinessController?.fetchedObjects?.count == 0 && searchController.isActive && !searchBarIsEmpty(){
                showNothingFoundView()
            } else {
                hideNothingFoundView()
            }
        case TableIndex.category.rawValue:
            if fetchCategoryNames?.count == 0 && searchController.isActive && !searchBarIsEmpty(){
                showNothingFoundView()
            } else {
                hideNothingFoundView()
            }
        default:
            print("ShowNothingLabelIfNoResults --> is very unhappy")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableViewArrayType {
        case TableIndex.category.rawValue:
            guard let currentCategory = fetchCategoryNames?[indexPath.row] else {return}
            listBusinesses(category: currentCategory)
        case TableIndex.business.rawValue:
            guard let currentBusiness = fetchBusinessController?.object(at: indexPath) else {return}
            showBusinessInfo(currentBusiness: currentBusiness)
        default:
            print("Illegal Value inside tableViewArrayType")
        }
    }
    
    func showBusinessInfo(currentBusiness: Business){
        let newVC = ShowBusinessDetailsController()
        newVC.business = currentBusiness
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    
    func getBusinessesFromCategoryName(category: String)-> [Business]{
        //This array is not NOT shown in this tableView.
        
        //'BARS' includes hits from other groups with "bar"
        //selectedCategoryPredicate = NSPredicate(format: "title CONTAINS[cd] %@", argumentArray: [category])
        
        //'MATCHES' is confused when string contains parenthesis.  Such as "American (New)"
        //selectedCategoryPredicate = NSPredicate(format: "title MATCHES[cd] %@", argumentArray: [category])
        
        selectedCategoryPredicate = NSPredicate(format: "title BEGINSWITH[cd] %@", argumentArray: [category])
        fetchCategoriesController = nil
        var businessArray = [Business]()    //Pushed into next ViewController
        fetchCategoriesController?.fetchedObjects?.forEach{businessArray.append($0.business!)}
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
}

