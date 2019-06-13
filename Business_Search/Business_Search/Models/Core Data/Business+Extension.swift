//
//  Business+Extension.swift
//  Business_Search
//
//  Created by admin on 6/3/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

extension Business {
    func isFavoriteTrue(context: NSManagedObjectContext){
        self.isFavorite = true
        do {
            try context.save()
        } catch {
            print("Short Error: \(error.localizedDescription)")
            print("Error saving Business.isFavorite = True\n\(error)")
        }
    }
    
    func isFavoriteFalse(context: NSManagedObjectContext){
        self.isFavorite = false
        do {
            try context.save()
        } catch {
            print("Short Error: \(error.localizedDescription)")
            print("Error saving Business.isFavorite = False\n\(error)")
        }
    }
    
    func isFavoriteChange(context: NSManagedObjectContext)->Bool{
        self.isFavorite = !self.isFavorite
        do {
            try context.save()
            return self.isFavorite
        } catch {
            print("Short Error: \(error.localizedDescription)")
            print("Error saving Business.isFavorite = !Business.isFavorite\n\(error)")
            return false
        }
    }
    
}
