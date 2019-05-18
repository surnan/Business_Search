//
//  AppDelegate.swift
//  Business_Search
//
//  Created by admin on 4/14/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

var limit = 50
var offset = 50
var radius = 250
var recordCountAtLocation = 0
var categoryMatch = 0

var locale = "en_US"

//PAIR - DONE
//Download - TOP
var latitude = 40.705199; var longitude = -74.007086    //100 Wall Street 10005
//var latitude = 40.706324; var longitude = -74.007808  //70 Pine Street 10005

//PAIR
//var latitude = 37.786882; var longitude = -122.399972 //140 Montgomery St, San Francisco, CA 94105
//var latitude = 37.786650; var longitude = -122.399520 //149 New Montgomery St, San Francisco, CA 94105

//PAIR - DONE
//var latitude = 40.76013750; var longitude = -73.91786550  //31-47 Steinway Street
//var latitude = 40.759153; var longitude = -73.919044     //31-90 Steinway St, Astoria, NY 11103




//  If context.has changes --> context.save on app goes to sleep or ends
/*
 do {
 } catch let error as NSError {
 print("Error = \(error), \(error.userInfo)")
 } 
 */


let colorArray: [UIColor] = [.paleGreen, .grey196, .solidOrange, .lemonChiffon,
                             .ghostWhite, .greyOrange, .darkOrange, .white, .lightRed,
                             .grey227, .plum, .dodgerBlue4, .tan, .teal, .skyBlue4]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dataController = DataController(modelName: "YelpDataModels")


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls[urls.count-1] as URL)    //prints app directory path
        
        dataController.load()
        
        //UIAppearance Proxy
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = UIColor.blue
        UINavigationBar.appearance().prefersLargeTitles = false
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]

        window = UIWindow()
        window?.makeKeyAndVisible()
        
        let startingVC = MenuController()
//        let startingVC = OpeningController()
        
        
        startingVC.dataController = dataController
        window?.rootViewController = CustomNavigationController(rootViewController: startingVC)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

