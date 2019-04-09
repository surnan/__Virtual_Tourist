//
//  CollectionMapViewsController+CollectionView.swift
//  __Virtual_Tourist
//
//  Created by admin on 4/8/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import MapKit
import CoreData


extension CollectionMapViewsController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Using 'currentPin.urlCount' in case returned photos is between 0 and 25
        return Int(currentPin.urlCount)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let photoAtThisCell = photosArrayFetchCount[indexPath.row] {
            let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIDCellLoaded, for: indexPath) as! FinalCollectionImageCell
            cell.myPhoto = photoAtThisCell
            return cell
        }

        
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIdLoadingCell, for: indexPath) as! FinalCollectionLoadingCell
        return cell
    }
}
