//
//  MapCollectionViewsController.swift
//  Virtual_Tourist
//
//  Created by admin on 4/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class CollectionMapViewsController: UIViewController {
    
    var currentPin: Pin!   //injected from MapController
    var dataController: DataController! //injected from MapController
    
    
    override func viewDidLoad() {
            view.backgroundColor = UIColor.yellow
        print("CollectionView ... Pin \(currentPin.coordinate)")
    }
}


