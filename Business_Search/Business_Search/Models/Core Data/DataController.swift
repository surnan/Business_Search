//
//  DataController.swift
//  __Virtual_Tourist
//
//  Created by admin on 4/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import CoreData


class DataController {
    
    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    var backGroundContext: NSManagedObjectContext!
    

    init(modelName: String) {
        persistentContainer = NSPersistentContainer.init(name: modelName)
    }
    
    
    func configureContexts(){
        backGroundContext = persistentContainer.newBackgroundContext()
        viewContext.automaticallyMergesChangesFromParent = true
        backGroundContext.automaticallyMergesChangesFromParent = true
        backGroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump    //priority
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func load(completion: (()-> Void)? = nil) {
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            guard error == nil else {
                fatalError((error?.localizedDescription)!)
            }
        }
        self.configureContexts()
        completion?() //Chance to Show loading screen while core data loads
    }
}
