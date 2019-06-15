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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableViewArrayType == TableIndex.category.rawValue {return nil}
        let action = UIContextualAction(style: .normal, title: "Favorite") { (action, view, myBool) in
            print(indexPath)
        }
        action.image = #imageLiteral(resourceName: "Favorite")
        action.backgroundColor = .lightBlue
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
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
            } else {
                self.predicateFavorite = NSPredicate(format: "id == %@", argumentArray: [currentBusiness.id!])
                self.fetchFavoriteBusinessController = nil
                print("currentBusiness.id --> \(currentBusiness.id!)")
                self.fetchFavoriteBusinessController?.fetchedObjects?.forEach{
                    self.dataController.viewContext.delete($0)
                    try! self.dataController.viewContext.save()
                }
                print("")
            }
        }
        guard let currentBusiness = self.fetchBusinessController?.object(at: indexPath) else {return nil}
        action.image = currentBusiness.isFavorite ?  #imageLiteral(resourceName: "cancel") : #imageLiteral(resourceName: "Favorite")
        action.backgroundColor =  currentBusiness.isFavorite ? .lightSteelBlue1 : .orange
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }

    
    func createFavoriteEntity(business: Business, context: NSManagedObjectContext){
        let newFavorite = FavoriteBusiness(context: context)
        newFavorite.alias = business.alias
        newFavorite.displayAddress = business.displayAddress
        newFavorite.displayPhone = business.displayPhone
        newFavorite.distance = business.distance
        newFavorite.id = business.id
        newFavorite.imageURL = business.imageURL
        newFavorite.isDelivery = business.isDelivery
        newFavorite.isFavorite = business.isFavorite
        newFavorite.isPickup = business.isPickup
        newFavorite.latitude = business.latitude
        newFavorite.longitude = business.longitude
        newFavorite.name = business.name
        newFavorite.price = business.price
        newFavorite.rating = business.rating
        newFavorite.reviewCount = business.reviewCount
        newFavorite.url = business.url
        
        let allCat = business.categories?.allObjects as! [Category]
        allCat.forEach({ (currentCategory) in
            let newFavoriteCategory = FavoriteCategory(context: context)
            newFavoriteCategory.title = currentCategory.title
            newFavoriteCategory.alias = currentCategory.alias
            newFavoriteCategory.favoriteBusiness = newFavorite
        })
        
        do {
            try context.save()
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
            _fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [myPredicate,
                                                                                         predicateCategoryLatitude,
                                                                                         predicateCategoryLongitude])
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
    
    
    func listBusinesses(category: String){
        //Not shown in this tableView.  It's to create array to push into next VC's tableView
        selectedCategoryPredicate = NSPredicate(format: "title CONTAINS[cd] %@", argumentArray: [category])
        fetchCategoriesController = nil
        
        var businessArray = [Business]()    //Pushed into next ViewController
        fetchCategoriesController?.fetchedObjects?.forEach{businessArray.append($0.business!)}
        businessArray = businessArray.filter{
            return $0.parentLocation?.latitude == latitude &&
                $0.parentLocation?.longitude == longitude
        }

        let newVC = MyTabController()
        newVC.businesses = businessArray
        newVC.categoryName = category
        navigationController?.pushViewController(newVC, animated: true)
    }
}

