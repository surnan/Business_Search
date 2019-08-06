//
//  File.swift
//  Business_Search
//
//  Created by admin on 6/27/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData


struct AppliedFilter: Codable {
    var dollar1         : Bool
    var dollar2         : Bool
    var dollar3         : Bool
    var dollar4         : Bool
    var priceExists     : Bool
    var favoritesAtTop  : Bool
    var minimumRating   : String
}


let filterConstant = "AppliedFilter"

class UserAppliedFilter {
    var appliedFilter: AppliedFilter!
    
    func loadFilterStruct(){
        guard let savedData = UserDefaults.standard.data(forKey: filterConstant) else {
            return
        }
        do {
            let filterData = try JSONDecoder().decode(AppliedFilter.self, from: savedData)
            appliedFilter = filterData
            print("")
        } catch {
            print("filterData try Error: \(error.localizedDescription) \n \(error)")
        }
    }
    
    
    func saveFilterStruct(aFilter: AppliedFilter){
        appliedFilter = aFilter
        do {
            let savedData = try JSONEncoder().encode(appliedFilter)
            UserDefaults.standard.set(savedData, forKey: filterConstant)
            print("")
        } catch {
            print("filterData try Error: \(error.localizedDescription) \n \(error)")
        }
    }
    
    static let shared = UserAppliedFilter()
    
    private var dollarOne: Bool?
    private var dollarTwo: Bool?
    private var dollarThree: Bool?
    private var dollarFour: Bool?
    private var priceExists: Bool?
    private var favoritesAtTop: Bool?
    private var minimumRating: String?
    
    var getOne: Bool {return dollarOne ?? false}
    var getTwo: Bool {return dollarTwo ?? false}
    var getThree: Bool {return dollarThree ?? false}
    var getFour: Bool {return dollarFour ?? false}
    var getNoPrice: Bool {return priceExists ?? false}
    var getMinimumRatingString: String {return minimumRating ?? "0.0"}
    var getFavoritesAtTop: Bool {return favoritesAtTop ?? true}
    
    var getMinimumRatingFloat: Float {
        if let _rating = minimumRating, let temp = Float(_rating){
            return temp
        }
        return 0.0
    }
    
    
    func reset(){
        //        UserDefaults.standard.set(true, forKey: AppConstants.dollarOne.rawValue)
        //        UserDefaults.standard.set(true, forKey: AppConstants.dollarTwo.rawValue)
        //        UserDefaults.standard.set(true, forKey: AppConstants.dollarThree.rawValue)
        //        UserDefaults.standard.set(true, forKey: AppConstants.dollarFour.rawValue)
        //        UserDefaults.standard.set(false, forKey: AppConstants.isPriceListed.rawValue)
        //        UserDefaults.standard.set("1.0", forKey: AppConstants.minimumRating.rawValue)
        //        UserDefaults.standard.set(false, forKey: AppConstants.isFavoritesToTop.rawValue)
        //        let defaultFilter = AppliedFilter(dollar1: true, dollar2: true, dollar3: true, dollar4: true, priceExists: false, favoritesAtTop: true, minimumRating: 1.0)
        
        appliedFilter = AppliedFilter(dollar1: true, dollar2: true, dollar3: true, dollar4: true, priceExists: false, favoritesAtTop: true, minimumRating: "1.0")
        saveFilterStruct(aFilter: appliedFilter)
        
        
    }
    
    func load(){
        dollarOne = UserDefaults.standard.object(forKey: AppConstants.dollarOne.rawValue) as? Bool ?? false
        dollarTwo = UserDefaults.standard.object(forKey: AppConstants.dollarTwo.rawValue) as? Bool ?? false
        dollarThree = UserDefaults.standard.object(forKey: AppConstants.dollarThree.rawValue) as? Bool ?? false
        dollarFour = UserDefaults.standard.object(forKey: AppConstants.dollarFour.rawValue) as? Bool ?? false
        priceExists = UserDefaults.standard.object(forKey: AppConstants.isPriceListed.rawValue) as? Bool ?? false
        minimumRating = UserDefaults.standard.object(forKey: AppConstants.minimumRating.rawValue) as? String ?? "0.0"
        favoritesAtTop = UserDefaults.standard.object(forKey: AppConstants.isFavoritesToTop.rawValue) as? Bool ?? false
    }
    
    
    func save(dollarOne: Bool, dollarTwo: Bool, dollarThree: Bool, dollarFour: Bool, noPrices: Bool, minimumRating: String, favoritesAtTop: Bool){
        UserDefaults.standard.set(dollarOne, forKey: AppConstants.dollarOne.rawValue)
        UserDefaults.standard.set(dollarTwo, forKey: AppConstants.dollarTwo.rawValue)
        UserDefaults.standard.set(dollarThree, forKey: AppConstants.dollarThree.rawValue)
        UserDefaults.standard.set(dollarFour, forKey: AppConstants.dollarFour.rawValue)
        UserDefaults.standard.set(noPrices, forKey: AppConstants.isPriceListed.rawValue)
        UserDefaults.standard.set(minimumRating, forKey: AppConstants.minimumRating.rawValue)
        UserDefaults.standard.set(favoritesAtTop, forKey: AppConstants.isFavoritesToTop.rawValue)
    }
    
    var isFilterOn: Bool {
        return !getOne || !getTwo || !getThree || !getFour || !getNoPrice || !(getMinimumRatingFloat == 1.0)
    }
    
    func getBusinessPredicate()->[NSCompoundPredicate]{
        var pricePredicates_OR_Compound = [NSPredicate]()
        var radiusOrPredicates_OR_Compound = [NSPredicate]()
        var returnCompoundPredicate = [NSCompoundPredicate]()
        
        // orPredicateForPrices - BUILD-UP
        if !(getOne && getTwo && getThree && getFour && getNoPrice) {
            if getOne {pricePredicates_OR_Compound.append(NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Business.price),"$"]))}
            if getTwo {pricePredicates_OR_Compound.append(NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Business.price),"$$"]))}
            if getThree {pricePredicates_OR_Compound.append(NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Business.price),"$$$"]))}
            if getFour {pricePredicates_OR_Compound.append(NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Business.price),"$$$$"]))}
            if getNoPrice {pricePredicates_OR_Compound.append(NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Business.price), nil as Any? as Any]))}
            //as Any? as Any ... from auto-complete.  Compiler would not stop complaining about 'nil' as value.  No errors but warnings.
        }
        
        if !pricePredicates_OR_Compound.isEmpty {
            let orPredicateForPrices = NSCompoundPredicate(orPredicateWithSubpredicates: pricePredicates_OR_Compound)   //OR
            returnCompoundPredicate.append(orPredicateForPrices)
        }
        
        if getMinimumRatingFloat > 1.0 {
            radiusOrPredicates_OR_Compound.append(NSPredicate(format: "%K >= %@", argumentArray: [#keyPath(Business.rating), getMinimumRatingFloat]))
            let andPredicateForRating = NSCompoundPredicate(andPredicateWithSubpredicates: radiusOrPredicates_OR_Compound)
            returnCompoundPredicate.append(andPredicateForRating)
        }
        return returnCompoundPredicate
    }
    
    
    func getFilteredBusinessArray(businessArray: [Business])->[Business]{
        var answer = [Business]()
        if getOne && getTwo && getThree && getFour && !getNoPrice  && getMinimumRatingFloat == 1.0{
            return businessArray
        }
        
        businessArray.forEach { (first) in
            if first.rating < Double(getMinimumRatingFloat) {return}
            switch first.price {
            case "$" where getOne: answer.append(first)
            case "$$" where getTwo: answer.append(first)
            case "$$$" where getThree: answer.append(first)
            case "$$$$" where getFour: answer.append(first)
            default:
                if getNoPrice {
                    answer.append(first)
                }
            }
        }
        return answer
    }
    
    func getCategoryPredicate()->[NSCompoundPredicate]{
        var pricePredicates_OR_Compound = [NSPredicate]()
        var radiusOrPredicates_OR_Compound = [NSPredicate]()
        var returnCompoundPredicate = [NSCompoundPredicate]()
        
        // OR predicates
        if !(getOne && getTwo && getThree && getFour && getNoPrice) {
            if getOne {pricePredicates_OR_Compound.append(
                NSPredicate(format: "%K == %@",
                            argumentArray: [#keyPath(Category.business.price),"$"]))}
            
            if getTwo {pricePredicates_OR_Compound.append(
                NSPredicate(format: "%K == %@",
                            argumentArray: [#keyPath(Category.business.price),"$$"]))}
            
            if getThree {pricePredicates_OR_Compound.append(
                NSPredicate(format: "%K == %@",
                            argumentArray: [#keyPath(Category.business.price),"$$$"]))}
            
            if getFour {pricePredicates_OR_Compound.append(
                NSPredicate(format: "%K == %@",
                            argumentArray: [#keyPath(Category.business.price),"$$$$"]))}
            
            if getNoPrice {pricePredicates_OR_Compound.append(
                NSPredicate(format: "%K == %@",
                            argumentArray: [#keyPath(Category.business.price), nil]))}
        }
        
        if !pricePredicates_OR_Compound.isEmpty {
            let orPredicateForPrices = NSCompoundPredicate(orPredicateWithSubpredicates: pricePredicates_OR_Compound)   //OR
            returnCompoundPredicate.append(orPredicateForPrices)
        }
        
        if getMinimumRatingFloat > 1.0 {
            radiusOrPredicates_OR_Compound.append(NSPredicate(format: "%K >= %@", argumentArray: [#keyPath(Category.business.rating), getMinimumRatingFloat]))
            let andPredicateForRating = NSCompoundPredicate(andPredicateWithSubpredicates: radiusOrPredicates_OR_Compound)
            returnCompoundPredicate.append(andPredicateForRating)
        }
        return returnCompoundPredicate
    }
    
    func showMyResultsInNSUserDefaults(){
        let myIndex = ["dollarOne", "dollarTwo", "dollarThree", "dollarFour", "isPriceListed", "isRatingListed"]
        var answers = [(key: String, value: Any)]()
        for item in Array(UserDefaults.standard.dictionaryRepresentation()) {
            if myIndex.contains(item.key) {
                answers.append(item)
            }
        }
        let items = Array(UserDefaults.standard.dictionaryRepresentation())
        print("answers:\n")
        answers.forEach{print($0)}
        print("\n***\ncount --> \(items.count)")
    }
}
