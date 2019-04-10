//
//  CollectionMapViewsController+Handlers.swift
//  __Virtual_Tourist
//
//  Created by admin on 4/8/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

//func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    //Using 'currentPin.urlCount' in case returned photos is between 0 and 25
//    return Int(currentPin.urlCount)
//}

extension CollectionMapViewsController {
    
    func removeSelectedPicture() {
        //Need to make CoreData changes to update currentPin.urlCount before changing array
        
    
        let backgroundContext: NSManagedObjectContext! = dataController.backGroundContext
        let pagesToDelete = Int32(deleteIndexSet.count)
        let currentPinID = currentPin.objectID
        
        self.deleteIndexSet.forEach { (deleteIndex) in //+1
            guard let photoToRemove = self.photosArrayFetchCount[deleteIndex.item] else {return}
            let photoToRemoveID = photoToRemove.objectID
            
            dataController.backGroundContext.perform {
                let backgroundPhoto = backgroundContext.object(with: photoToRemoveID) as! Photo
                backgroundContext.delete(backgroundPhoto)
                try? backgroundContext.save()
            }
        } //-1
        
        
         dataController.backGroundContext.perform {
            let backgroundPin = backgroundContext.object(with: currentPinID) as! Pin
            backgroundPin.photoCount = backgroundPin.photoCount - pagesToDelete
            backgroundPin.urlCount = backgroundPin.urlCount - pagesToDelete
            try? backgroundContext.save()
            print("") //stuff is deleted
        }
    }
    
    

    
    
    func removeSelectedPicture2() {
        //Need to make CoreData changes to update currentPin.urlCount before changing array
        
        
        
//        let backgroundContext: NSManagedObjectContext! = dataController.backGroundContext
//        let pagesToDelete = Int32(deleteIndexSet.count)
//        let currentPinID = currentPin.objectID
        let context = dataController.viewContext
        
        var currentIndex: Int32 = 0
        
        context.perform {
            for (index, photo) in self.photosArrayFetchCount.enumerated(){
                guard let _photo = photo else {continue}
                let _indexPath = IndexPath(item: index, section: 0)
                let _photoID = _photo.objectID
                
                let currentPhoto = context.object(with: _photoID) as! Photo
                
                if self.deleteIndexSet.contains(_indexPath){
                    context.delete(currentPhoto)
                    
                    if index == self.photosArrayFetchCount.count - 1 {
                        let _currentPinID = self.currentPin.objectID
                        let _currentPin = context.object(with: _currentPinID) as! Pin
//                        _currentPin.urlCount = currentIndex
//                        _currentPin.photoCount = currentIndex
                        
                        _currentPin.urlCount = _currentPin.urlCount - Int32(self.deleteIndexSet.count)
                        _currentPin.photoCount = _currentPin.photoCount - Int32(self.deleteIndexSet.count)
                        
                        try? context.save()
                        DispatchQueue.main.async {
                            self.deleteIndexSet.removeAll()
                            self.loadCollectionArray()
                            self.myCollectionView.reloadData()
                        }
                    }
                    continue
                } else {
                    currentPhoto.index = currentIndex
                    currentIndex = currentIndex + 1
                }
                
                if index == self.photosArrayFetchCount.count - 1 {
                    let _currentPinID = self.currentPin.objectID
                    let _currentPin = context.object(with: _currentPinID) as! Pin
                    _currentPin.urlCount = currentIndex
                    _currentPin.photoCount = currentIndex
                    try? context.save()
                    DispatchQueue.main.async {
                        self.deleteIndexSet.removeAll()
                        self.loadCollectionArray()
                        self.myCollectionView.reloadData()
                    } 
                }
            }
        }

    }
    
    
    func stuff(){
        let myQueue = OperationQueue()
        
        let blockOne = BlockOperation {
            // self.removeSelectedPicture()
            self.removeSelectedPicture2()
        }
        
        
        myQueue.addOperations([blockOne], waitUntilFinished: false)
        print("") //nothing happens here
    }

    
    
    /*
 dataController.backGroundContext.perform {
 let backgroundPhotoToRemove = backgroundContext.object(with: photoToRemoveID) as! Photo
 pagesToDelete = pagesToDelete + 1
 backgroundContext.delete(backgroundPhotoToRemove)
 self.currentPin.photoCount = self.currentPin.photoCount - pagesToDelete
 self.currentPin.urlCount = self.currentPin.urlCount - pagesToDelete
 try? backgroundContext.save()
 DispatchQueue.main.async {
 self.deleteIndexSet.removeAll()
 self.loadCollectionArray()
 }
 }
 */
    
    @objc func handleNewLocationButton(_ sender: UIButton){
        if sender.isSelected {
            print("DELETE")
            stuff()
//            removeSelectedPicture()
            
//            myCollectionView.reloadData()
            

        } else {
            print("-- GET NEW PICTURES --")
            
            deleteAllPhotosOnPin(currentPin)
            
            dataController.viewContext.perform { //1
                print("handle -3")
                //let pinToAdd = Pin(context: self.dataController.viewContext) //moving above 1 causes pin not drop
                //It's working in this scenario.  Buggy when adding/inserting pin
                self.currentPin.pageNumber = self.currentPin.pageNumber + 1
                self.currentPin.photoCount = 0
                try? self.dataController.viewContext.save()
                _ = FlickrClient.getAllPhotoURLs(currentPin: self.currentPin, fetchCount: fetchCount, completion: self.handleGetAllPhotoURLs(pin:urls:error:))
            }
        }
    }
    
    
    
    
    
    
    func handleGetAllPhotoURLs(pin: Pin, urls: [URL], error: Error?){
        let backgroundContext: NSManagedObjectContext! = dataController.backGroundContext
        if let error = error {
            print("func mapView(_ mapView: MKMapView, didSelect... \n\(error)")
            return
        }
        
        let pinId = pin.objectID
    
        backgroundContext.perform {
            let backgroundPin = backgroundContext.object(with: pinId) as! Pin
            backgroundPin.urlCount = Int32(urls.count)
            try? backgroundContext.save()
        }
        
        for (index, currentURL) in urls.enumerated() {
            URLSession.shared.dataTask(with: currentURL, completionHandler: { (imageData, response, error) in
                guard let imageData = imageData else {return}
                connectPhotoAndPin(dataController: self.dataController, currentPin:  pin , data: imageData, urlString: currentURL.absoluteString, index: index)
                
                /////////
                self.myCollectionView.reloadData()
                /////////
                
            }).resume()
        }
    }
    
    func deleteAllPhotosOnPin(_ pinToChange: Pin) {
        let fetch111 = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        fetch111.predicate = NSPredicate(format: "pin = %@", argumentArray: [pinToChange])
        let request = NSBatchDeleteRequest(fetchRequest: fetch111)
        _ = try? self.dataController.backGroundContext.execute(request)
        try? self.dataController.viewContext.save()
    }
}
