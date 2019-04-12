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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let photoAtSelection = photosArrayFetchCount[indexPath.item], let _ = photoAtSelection.imageData else {
            return
        }
        
        
        
        if deleteIndexSet.contains(indexPath) {
            deleteIndexSet.remove(indexPath)
        } else {
            deleteIndexSet.insert(indexPath)
        }
        
        myCollectionView.reloadItems(at: [indexPath]) //To show fade/non-fade effect

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Using 'currentPin.urlCount' in case photos are still downloading pin.photoCount is still increasing
        
        if currentPin.urlCount != 0 {
            //When network is very slow and still waiting for pin.urlCount, viewDidLoad will auto-start activityView
            activityView.stopAnimating()
        }
        
        return Int(currentPin.urlCount)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //crash if clicking on cell while cell is Loading State
        if deleteIndexSet.contains(indexPath) {
            let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIDCellIsSelected, for: indexPath) as! FinalCollectionSelectedImageCell
            cell.myPhoto = photosArrayFetchCount[indexPath.row]!
            return cell
        }
        
        if let photoAtThisCell = photosArrayFetchCount[indexPath.row] {
            let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIDCellLoaded, for: indexPath) as! FinalCollectionImageCell
            cell.myPhoto = photoAtThisCell
            return cell
        }
        
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIdLoadingCell, for: indexPath) as! FinalCollectionLoadingCell
        return cell
    }
}
