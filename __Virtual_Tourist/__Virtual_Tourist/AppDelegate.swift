//
//  AppDelegate.swift
//  __Virtual_Tourist
//
//  Created by admin on 4/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

let API_KEY = "f5963392b48503b5e16b85a3cb31cf31"
let SECRET_KEY = "c911ea3d3998b21f"
var fetchCount = 21 //Reset CoreData if changed


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var dataController = DataController(modelName: "FlickrDataModels")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls[urls.count-1] as URL)    //prints app directory path
        
        dataController.load()
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = UIColor.ghostWhite
        let _PinsMapController = PinsMapController()
        _PinsMapController.dataController = dataController
        let _navigationWindow = UINavigationController(rootViewController: _PinsMapController)
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = _navigationWindow
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        saveViewContext()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        saveViewContext()
    }
    
    
    //MARK:- My functions
    func saveViewContext(){
        
        do {
            try self.dataController.viewContext.save()
        } catch let saveErr {
            print("Error: Core Data Save Error within AppDelegate(...)\nCode: \(saveErr.localizedDescription)")
            print("Full Error Details: \(saveErr)")
        }
    }
}

