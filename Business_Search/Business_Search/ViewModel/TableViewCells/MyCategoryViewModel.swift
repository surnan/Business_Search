//
//  MyCategoryViewModel.swift
//  Business_Search
//
//  Created by admin on 7/24/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

struct MyCategoryViewModel {
    
    var name: String!
    var count: Int!
    var originalColor: UIColor!
    var latitude: Double!
    var longitude: Double!
    var dataController: DataController!
    
    lazy var predicateCategoryLatitude = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Category.business.parentLocation.latitude), latitude!])
    lazy var predicateCategoryLongitude = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Category.business.parentLocation.longitude), longitude!])
    
    init(name: String, colorIndex: IndexPath, latitude: Double, longitude: Double, dataController: DataController) {
        self.name = name
        originalColor = colorArray[colorIndex.row % colorArray.count]
        self.latitude = latitude
        self.longitude = longitude
        self.dataController = dataController
        test()
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
            print("Failed to get Count inside cellForRowAt: \n\(error)")
        }
    }
}
