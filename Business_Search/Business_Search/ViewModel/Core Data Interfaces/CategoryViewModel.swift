//
//  CategoryViewModel {.swift
//  Business_Search
//
//  Created by admin on 7/30/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import CoreData

class CategoryViewModel {
    private var dataController: DataController
    private var latitude    : Double
    private var longitude   : Double

    private var predicateCategoryLatitude: NSPredicate {
       return NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Category.business.parentLocation.latitude), latitude])
    }
    
    private var predicateCategoryLongitude: NSPredicate {
      return NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Category.business.parentLocation.longitude), longitude])
    }
    
    private var selectedCategoryPredicate: NSPredicate? {
        didSet {
            NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: nil) //Just in case
            fetchCategoriesController?.fetchRequest.predicate = selectedCategoryPredicate
        }
    }
    
    private var fetchCategoriesController: NSFetchedResultsController<Category>? { //+1
        didSet {    //+2
            if fetchCategoriesController == nil { //+3
                fetchCategoriesController = {   //+4
                    let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
                    
                    var predicate: [NSPredicate] = [predicateCategoryLatitude, predicateCategoryLongitude]
                    if let _selectedPredicate = selectedCategoryPredicate {predicate.append(_selectedPredicate)}
                    
                    let openingControllerPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicate)
                    var filterControllerPredicate  = UserAppliedFilter.shared.getCategoryPredicate()
                    filterControllerPredicate.append(openingControllerPredicate)
                    
                    fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: filterControllerPredicate)
                    
                    let sortDescriptor = NSSortDescriptor(keyPath: \Category.title, ascending: true)
                    fetchRequest.sortDescriptors = [ sortDescriptor]
                    let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                               managedObjectContext: dataController.viewContext,
                                                                               sectionNameKeyPath: nil,
                                                                               cacheName: nil)
                    do {
                        try aFetchedResultsController.performFetch()
                    } catch let error {
                        fatalError("Error 0DA: Unresolved error \(error)")
                    }
                    return aFetchedResultsController
                }() //-4
            }   //-3
        }   //-2
    }   //-1
    
    //MARK:- NON-Private
    init(dataController: DataController, lat: Double, lon: Double) {
        self.dataController = dataController
        self.latitude       = lat
        self.longitude      = lon
    }
    
    var getCount: Int {return fetchCategoriesController?.fetchedObjects?.count ?? 0}
    var isEmpty: Bool {return fetchCategoriesController?.fetchedObjects?.count == 0}
    var allObjects: [Category] {return fetchCategoriesController?.fetchedObjects ?? []}

    func reload() {fetchCategoriesController = nil}
    func search(search: String?){
        if let search = search {
            selectedCategoryPredicate    = NSPredicate(format: "title CONTAINS[cd] %@", argumentArray: [search])
            reload()
        } else {
            selectedCategoryPredicate    = nil
            reload()
        }
    }
}
