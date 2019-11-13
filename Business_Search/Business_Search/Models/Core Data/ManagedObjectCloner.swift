//
//  ManagedObjectCloner.swift
//  Business_Search
//
//  Created by admin on 6/3/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

class ManagedObjectCloner: NSObject {
    
    static func cloneObject(source :NSManagedObject, context :NSManagedObjectContext) -> NSManagedObject{
        let entityName = source.entity.name
        let cloned = NSEntityDescription.insertNewObject(forEntityName: entityName!, into: context)
        
        let attributes = NSEntityDescription.entity(forEntityName: entityName!, in: context)?.attributesByName
        
        for (key,_) in attributes! {
            cloned.setValue(source.value(forKey: key), forKey: key)
        }
        
        let relationships = NSEntityDescription.entity(forEntityName: entityName!, in: context)?.relationshipsByName
        for (key,_) in relationships! {
            let sourceSet = source.mutableSetValue(forKey: key)
            let clonedSet = cloned.mutableSetValue(forKey: key)
            let e = sourceSet.objectEnumerator()
            
            var relatedObj = e.nextObject() as? NSManagedObject
            
            while ((relatedObj) != nil) {
                let clonedRelatedObject = ManagedObjectCloner.cloneObject(source: relatedObj!, context: context)
                clonedSet.add(clonedRelatedObject)
                relatedObj = e.nextObject() as? NSManagedObject
            }
        }
        return cloned
    }
}

extension FavoriteBusiness {
    var distance2: Double {
        let lat = latitude
        return 20.0
    }
}
