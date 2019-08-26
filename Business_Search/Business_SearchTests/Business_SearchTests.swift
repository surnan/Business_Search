//
//  Business_SearchTests.swift
//  Business_SearchTests
//
//  Created by admin on 8/13/19.
//  Copyright © 2019 admin. All rights reserved.
//

import XCTest
import CoreData

@testable import Business_Search



class Business_SearchTests: XCTestCase {
    var dataController                  = DataController(modelName: "YelpDataModels")
    var context: NSManagedObjectContext {
        return dataController.viewContext
    }
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCoreData(){
        
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
