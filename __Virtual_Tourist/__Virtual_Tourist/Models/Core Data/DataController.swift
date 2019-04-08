//
//  DataController.swift
//  __Virtual_Tourist
//
//  Created by admin on 4/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import CoreData


class DataController {
    
    let persistentContainer: NSPersistentContainer
    init(modelName: String) {
        persistentContainer = NSPersistentContainer.init(name: modelName)
    }
    
    var viewContext: NSManagedObjectContext { return persistentContainer.viewContext }
    var backGroundContext: NSManagedObjectContext!
    
    func configureContexts(){
        backGroundContext = persistentContainer.newBackgroundContext()
        viewContext.automaticallyMergesChangesFromParent = true
        backGroundContext.automaticallyMergesChangesFromParent = true
        backGroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump    //background gets priority @ conflict
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func load(completion: (()-> Void)? = nil) {
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            guard error == nil else {
                fatalError((error?.localizedDescription)!)
            }
        }
        self.configureContexts()
        completion?() //Show loading screen while core data loads
    }
}
