//
//  AppDelegate.swift
//  Business_Search
//
//  Created by admin on 4/14/19.
//  Copyright © 2019 admin. All rights reserved.
//


import UIKit
import GoogleMaps


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    var dataController                  = DataController(modelName: "YelpDataModels")
    //lazy var appNavigationController    = CustomNavigationController(rootViewController: MenuController())
//    lazy var appNavigationController    = CustomNavigationController()
//    lazy var appRouter                  = Router(navigationController: self.appNavigationController)
//    lazy var appCoordinator             = AppCoordinator(router: self.appRouter, dataController: self.dataController)
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let firstVC                    = MenuController()
        let appNavigationController    = CustomNavigationController(rootViewController: firstVC)
        let appRouter                  = Router(navigationController: appNavigationController)
        let appCoordinator             = AppCoordinator(router: appRouter, dataController: dataController)
        
        
        
        
        
        GMSServices.provideAPIKey("AIzaSyDGg9KrIhBikjHA--5OTYlRufyTfQl2N7w")
        radius = UserDefaults.standard.object(forKey: AppConstants.radius.rawValue) as? Int ?? 350
        UserAppliedFilter.shared.load()
        
        //Print path to Documents folder to help browse for CoreData
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls[urls.count-1] as URL)    //prints app directory path
        dataController.load()
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = UIColor.lightRed
        UINavigationBar.appearance().prefersLargeTitles = false
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        UITabBar.appearance().barTintColor = UIColor.lightRed
        UITabBar.appearance().tintColor = UIColor.white
        
//        let vc = MenuController()
//        vc.dataController = dataController
//        let navController = CustomNavigationController(rootViewController: vc)
//        window = UIWindow(frame: UIScreen.main.bounds) //window = UIWindow()
//        window?.rootViewController = navController
//        window?.makeKeyAndVisible()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = appCoordinator.toPresentable()
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        appCoordinator.start()
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
