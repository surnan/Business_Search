//
//  Business_SearchTests.swift
//  Business_SearchTests
//
//  Created by admin on 8/13/19.
//  Copyright © 2019 admin. All rights reserved.
//

import XCTest
import CoreData
import UIKit

@testable import Business_Search
//@testable import "Business Search"

// latitude max = 90
// longitude max = 180

class Business_SearchTests: XCTestCase {
    var dataController                  = DataController(modelName: "YelpDataModels")
    var context: NSManagedObjectContext {
        return dataController.viewContext
    }
    
    var myLocation      = LocationStruct()
    let categoryStruct1 = CategoryStruct(alias: "pizza", title: "Pizza")
    let categoryStruct2 = CategoryStruct(alias: "bakery", title: "Bakery")
    var myBusiness      = BusinessStruct(name: "Carve", displayAddress: "760 8th Ave")
    
    lazy var newLocation = Location(context: context)
    lazy var newBusiness = Business(context: context)
    
    
    let evenIndex   = IndexPath(row: 0, section: 0)
    let oddIndex    = IndexPath(row: 1, section: 0)
    

    
    func testNothing(){}
    
    struct _BusinessCellViewModel {
        private let topStringAttributes: [NSAttributedString.Key: Any]   = [
            .font:UIFont.boldSystemFont(ofSize: 16),
            .strokeColor:UIColor.blue
        ]
        
        private let bottomStringAttributes: [NSAttributedString.Key: Any] = [
            .font:UIFont.italicSystemFont(ofSize: 13),
            .strokeColor : UIColor.darkGray
        ]
        
        private var favoriteImage: UIImage!
        private var myLabelAttributedString: NSAttributedString!
        private var originalColor: UIColor!
        private var accessoryType: UITableViewCell.AccessoryType!
        
        var getFavoriteImage: UIImage {return favoriteImage}
        var getMyLabelAttributedString: NSAttributedString {return myLabelAttributedString}
        var getOriginalColor: UIColor {return originalColor}
        var getAccessoryType: UITableViewCell.AccessoryType {return accessoryType}
        
        
        init(business: Business, colorIndex: IndexPath) {
            if let displayAddress = business.displayAddress,
                let address = displayAddress.split(separator: "?").first,
                let name = business.name {
                let nameNewLine = "\(name)\n"
                let topString = NSMutableAttributedString(string: nameNewLine, attributes: topStringAttributes)
                let bottomString = NSMutableAttributedString(string: String(address), attributes: bottomStringAttributes)
                topString.append(bottomString)
                myLabelAttributedString = topString
            }
            favoriteImage = business.isFavorite ? #imageLiteral(resourceName: "Favorite") : #imageLiteral(resourceName: "UnFavorite")
            originalColor = getColor(indexPath: colorIndex)
            accessoryType = .disclosureIndicator
        }
    }

    func testBusinessCellViewModel(){
        let evenCellModel    = BusinessCellViewModel(business: newBusiness, colorIndex: evenIndex)
        let oddCellModel     = BusinessCellViewModel(business: newBusiness, colorIndex: evenIndex)
        
        evenCellModel.getMyLabelAttributedString.string =

    
    }
    
    
    override func setUp() {
        super.setUp()
        testPopulateCoreData()
    }
    
    override func tearDown() {
        super.tearDown()
        testDeleteCoreDataUnitTestEntities()
    }
    
    func testRadiusCheck(){
        XCTAssert(radius < 1)
    }
    
    func testRadiusCheck2(){
        XCTAssert(radius > 1)
    }
}

//func testPerformanceExample() {
//    // This is an example of a performance test case.
//    self.measure {
//        // Put the code you want to measure the time of here.
//    }
//}

extension Business_SearchTests {
    
    func testPopulateCoreData(){
        dataController.load()
        let result = _createLocation(locationStruct: myLocation, context: context)
        XCTAssertEqual(result, true)
    }
    
    func testDeleteCoreDataUnitTestEntities(){
        _deleteLocation(lat: 250.01, lon: 250.01)
    }
    
    func _createLocation(locationStruct: LocationStruct , context: NSManagedObjectContext)->Bool{
        let item = locationStruct
        newLocation.latitude = item.latitude
        newLocation.longitude = item.longitude
        newLocation.radius = Int32(item.radius)
        newLocation.totalBusinesses = Int32(item.totalBusinesses)
        
        do {
            try context.save()
            addBusiness(id: newLocation.objectID)
            return true
        } catch {
            print("Unit Test Fail: Error saving func addLocation() --\n\(error)")
            print("Localized Error saving func addLocation() --\n\(error.localizedDescription)")
            return false
        }
    }
    
    func addBusiness(id: NSManagedObjectID?){
        guard let id = id else {return}
        let parent = context.object(with: id) as! Location
        newBusiness.name = "asdf"
        newBusiness.parentLocation = parent
        newBusiness.alias = "asdf"
        newBusiness.id = "asdf"
        newBusiness.isDelivery = true
        newBusiness.isFavorite = false
        newBusiness.isPickup = true
        newBusiness.latitude = 1111
        newBusiness.longitude = 1111
        newBusiness.displayAddress = "140 Broadway"
        
        do {
            try context.save()
            addCategories(id: newBusiness.objectID)
            print("")
        } catch {
            print("error")
        }
    }
    
    func addCategories(id: NSManagedObjectID?){
        guard let id = id else {return}
        let parent = context.object(with: id) as! Business
        let categories = [categoryStruct1, categoryStruct2]
        categories.forEach { (element) in
            let newCategory = Category(context: context)
            newCategory.title = element.title
            newCategory.alias = element.alias
            newCategory.business = parent
        }
        do {
            try context.save()
        } catch {
            print("Category error")
        }
    }
    
    func _deleteLocation(lat: Double, lon: Double){
        //Can't add the same store twice - error if 'dataController.load' here
        let fetchRequest = NSFetchRequest<Location>(entityName: "Location")
        let predicate = NSPredicate(format: "latitude == %@ AND longitude == %@", argumentArray: [lat, lon])
        fetchRequest.predicate = predicate
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
        } catch {
            print("Error: Unable to delete CoreData in Unit Test \nLat = \(lat) ... Lon = \(lon)")
        }
    }
}
