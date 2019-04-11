//
//  CollectionMapViewsController+Protocol.swift
//  __Virtual_Tourist
//
//  Created by admin on 4/8/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import MapKit
import CoreData


extension CollectionMapViewsController {
    func refreshCollectionView() {
//        if taskToGetPhotoURLs?.state == URLSessionTask.State.running {
//            print("\nTASK IS RUNNING")
//        }
//        print("==============taskToGetPhotoURLs?.state.rawValue ----> \(taskToGetPhotoURLs?.state.rawValue)\n")
        
//        if taskToGetPhotoURLs?.state == nil {
//            if currentPin.urlCount == 0 {
//                showEmptyMessage()
//            }
//        }
//
//
        DispatchQueue.main.async {
            self.deleteIndexSet.removeAll()
            self.loadCollectionArray()
            self.myCollectionView.reloadData()
            print("")
        }
    }
    
    
    
    
    
}
