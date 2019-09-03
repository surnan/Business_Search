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
    
    func _createLocation(locationStruct: LocationStruct , context: NSManagedObjectContext)->Bool{
        let item = locationStruct
        let newLocation = Location(context: context)
        newLocation.latitude = item.latitude
        newLocation.longitude = item.longitude
        newLocation.radius = Int32(item.radius)
        newLocation.totalBusinesses = Int32(item.totalBusinesses)
        do {
            try context.save()
            return true
        } catch {
            print("Error 09A: Error saving func addLocation() --\n\(error)")
            print("Localized Error saving func addLocation() --\n\(error.localizedDescription)")
            return false
        }
    }
    
    func _deleteLocation(lat: Double, lon: Double){
        dataController.load()
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
    
    func testDelete(){
        _deleteLocation(lat: 250.01, lon: 250.01)
    }
    
    func testCode(){
        dataController.load()
        let result = _createLocation(locationStruct: myLocation, context: context)
        XCTAssertEqual(result, true)
    }
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    

    
    
    

    func testRadiusCheck(){
        XCTAssert(radius < 1)
    }
    
    func testRadiusCheck2(){
        XCTAssert(radius > 1)
    }
}





//override func setUp() {
//    // Put setup code here. This method is called before the invocation of each test method in the class.
//}
//
//override func tearDown() {
//    // Put teardown code here. This method is called after the invocation of each test method in the class.
//}
//
//func testExample() {
//    // This is an example of a functional test case.
//    // Use XCTAssert and related functions to verify your tests produce the correct results.
//}
//
//func testPerformanceExample() {
//    // This is an example of a performance test case.
//    self.measure {
//        // Put the code you want to measure the time of here.
//    }
//}
