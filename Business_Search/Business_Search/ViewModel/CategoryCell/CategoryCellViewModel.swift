//
//  MyCategoryViewModel.swift
//  Business_Search
//
//  Created by admin on 7/24/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

struct CategoryCellViewModel {
    
    private var name: String
    var getName: String {return name}
    
    private var count: Int!
    var getCountString: String {
        let matches = count == 1 ? "match" : "matches"
        let result = "\(count ?? 0) \(matches)\nfound"
        return result
    }
    
    private var originalColor: UIColor!
    var getOriginalColor: UIColor {return originalColor}
    
    private var latitude: Double
    private var longitude: Double
    private var dataController: DataController
    
    //lazy var predicateCategoryLatitude = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Category.business.parentLocation.latitude), latitude!])
    //lazy var predicateCategoryLongitude = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Category.business.parentLocation.longitude), longitude!])
    
    var predicateCategoryLatitude: NSPredicate {
      return NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Category.business.parentLocation.latitude), latitude])
    }
    
    var predicateCategoryLongitude: NSPredicate {
      return NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Category.business.parentLocation.longitude), longitude])
    }
    
    
    
    init(name: String, colorIndex: IndexPath, latitude: Double, longitude: Double, dataController: DataController) {
        self.name = name
        originalColor = colorArray[colorIndex.row % colorArray.count]
        self.latitude = latitude
        self.longitude = longitude
        self.dataController = dataController
        test()
        print("")
    }

    
    mutating func test(){
        let _fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        let myPredicate = NSPredicate(format: "%K == %@", #keyPath(Category.title), name)
        let filterControllerPredicate = UserAppliedFilter.shared.getCategoryPredicate()        //FilterController Singleton
        
        var tempPredicate = [myPredicate, predicateCategoryLatitude, predicateCategoryLongitude]
        filterControllerPredicate.forEach{tempPredicate.append($0)}
        _fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: tempPredicate)
        do {
            let _count = try dataController.viewContext.count(for: _fetchRequest)
            count = _count
        } catch {
            count = 0
            print("Error 05A: Failed to get Count inside cellForRowAt: \n\(error)")
        }
    }
}
