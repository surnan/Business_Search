//
//  AppDelegate.swift
//  Business_Search
//
//  Created by admin on 4/14/19.
//  Copyright © 2019 admin. All rights reserved.
//


import UIKit
import GoogleMaps

let limit = 50
var offset = 50
var radius = 350           // NSUserDefaults

var recordCountAtLocation = 0
var categoryMatch = 0
var yelpMaxPullCount = 1000


enum AppConstants:String {
    case limit, offset, radius, recordCountAtLocation, yelpMaxPullCount, dollarOne, dollarTwo, dollarThree, dollarFour, isPriceListed, isRatingListed, minimumRating, greetingMessage
}

//.grey196
let colorArray: [UIColor] = [ .lemonChiffon, .paleGreen, .white, .solidOrange,
                             .grey227, .darkOrange, .greyOrange, .skyBlue4,
                             .lightGray, .plum, .white, .tan, 
                             .ghostWhite, .teal, .steelBlue, .snowHalf, .steelBlue4]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var dataController = DataController(modelName: "YelpDataModels")


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyDGg9KrIhBikjHA--5OTYlRufyTfQl2N7w")
        radius = UserDefaults.standard.object(forKey: AppConstants.radius.rawValue) as? Int ?? 350
        
        UserAppliedFilter.shared.load()
        //showMyResultsInNSUserDefaults()
        
        
        //Print path to Documents folder to help browse for CoreData
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls[urls.count-1] as URL)    //prints app directory path
        dataController.load()
        
        //UIAppearance Proxy
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = UIColor.lightRed
        UINavigationBar.appearance().prefersLargeTitles = false
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]

        UITabBar.appearance().barTintColor = UIColor.lightRed
        UITabBar.appearance().tintColor = UIColor.white
        
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        let startingVC = MenuController()
        startingVC.dataController = dataController
        window?.rootViewController = CustomNavigationController(rootViewController: startingVC)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        saveDefaults()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        saveDefaults()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        saveDefaults()
    }
    
    func saveDefaults(){
        UserDefaults.standard.set(radius, forKey: AppConstants.radius.rawValue)
    }
}

