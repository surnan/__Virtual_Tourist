//
//  CollectionMapViewsController+Handlers.swift
//  __Virtual_Tourist
//
//  Created by admin on 4/8/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension CollectionMapViewsController {
    
    @objc func handleNewLocationButton(_ sender: UIButton){
        if sender.isSelected {
            print("DELETE")
            deleteIndexSet.removeAll()
            myCollectionView.reloadData()
        } else {
            print("-- GET NEW PICTURES --")
        }
    }
}
