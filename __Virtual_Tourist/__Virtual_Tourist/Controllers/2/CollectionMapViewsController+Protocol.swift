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
        DispatchQueue.main.async {
            self.deleteIndexSet.removeAll()
            self.loadCollectionArray()
            self.myCollectionView.reloadData()
            
            if !self.currentPin.isDownloading {
                self.emptyLabel.isHidden = self.currentPin.urlCount == 0 ? false : true
            }
        }
    }
}
