//
//  CategoryViewModel.swift
//  Business_Search
//
//  Created by admin on 7/29/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import CoreData

class CategoryCountViewModel {
    private var delegate        : OpenControllerType
    private var dataController  : DataController
    private var fetchCategoryArrayNamesPredicate: NSPredicate? = nil
    
    private var predicateCategoryLatitude: NSPredicate {
      return NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Category.business.parentLocation.latitude), delegate.getLatitude])
    }
    
    private var predicateCategoryLongitude: NSPredicate {
        return NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Category.business.parentLocation.longitude), delegate.getLongitude])
    }
    
    private var fetchCategoryNames: [String]? { //Populate Search Group listings
        didSet {
            if fetchCategoryNames == nil {
                //By default, returns .ManagedObjectResultType = Actual Objects
                // .dictionaryResultType used for 'returnsDistinctResults'
                let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "Category")
                fetchRequest.resultType = .dictionaryResultType
                fetchRequest.propertiesToFetch = ["title"]
                fetchRequest.returnsDistinctResults = true
                let sortDescriptor = [NSSortDescriptor(key: "title", ascending: true)]
                fetchRequest.sortDescriptors = sortDescriptor
                
                var predicate: [NSPredicate] = [predicateCategoryLatitude, predicateCategoryLongitude]
                if let _predicate = fetchCategoryArrayNamesPredicate {predicate.append(_predicate)}
                let openingControllerPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicate)
                
                var filterControllerPredicate = UserAppliedFilter.shared.getCategoryPredicate()
                filterControllerPredicate.append(openingControllerPredicate)
                fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: filterControllerPredicate)
                
                let controller = NSFetchedResultsController(
                    fetchRequest: fetchRequest,
                    managedObjectContext: dataController.viewContext,
                    sectionNameKeyPath: nil,    // just for demonstration: nil = dont split into section
                    cacheName: nil              // and nil = dont cache
                )
                
                do {
                    try controller.performFetch()
                    let temp = controller.fetchedObjects
                    var answer = [String]()
                    temp?.forEach({ (element) in
                        let tempString = element.value(forKey: "title") as! String
                        answer.append(tempString)
                    })
                    fetchCategoryNames = answer
                } catch {
                    print("Error 0CA: Fail to PerformFetch inside categoryFinalArray:")
                }
            }
        }
    }
    
    //MARK:- NON-Private
    var getCount    : Int   {return fetchCategoryNames?.count ?? 0}
    var isEmpty     : Bool  {return fetchCategoryNames?.count == 0}

    
    init(delegate: OpenControllerType, dataController: DataController) {
        self.dataController = dataController
        self.delegate       = delegate
    }
    
    
    //It's OK for forced-unwrap because it has to exist at this stage
    func objectAt(indexPath: IndexPath)-> String {return fetchCategoryNames![indexPath.row]}
    func fetchedObjects() -> [String]{return fetchCategoryNames ?? []}
    func reload(){fetchCategoryNames = nil}
    
    func search(search: String?){
        if let search = search {
            fetchCategoryArrayNamesPredicate = NSPredicate(format: "title CONTAINS[cd] %@", argumentArray: [search])
            fetchCategoryNames = nil
        } else {
            fetchCategoryArrayNamesPredicate = nil
            fetchCategoryNames = nil
        }
    }
}
