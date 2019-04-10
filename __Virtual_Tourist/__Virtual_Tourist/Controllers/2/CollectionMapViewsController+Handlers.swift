//
//  CollectionMapViewsController+Handlers.swift
//  __Virtual_Tourist
//
//  Created by admin on 4/8/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData


extension CollectionMapViewsController {
    
    func removeSelectedPicture() {
        //Need to make CoreData changes to update currentPin.urlCount before changing array
        
        let context = dataController.viewContext
        
        var newIndex: Int32 = 0
        
        context.perform {
            for (loopIndex, photo) in self.photosArrayFetchCount.enumerated(){
                guard let _photo = photo else {continue}
                let indexPath = IndexPath(item: loopIndex, section: 0)
                
                let _photoID = _photo.objectID; let _currentPinID = self.currentPin.objectID
                let currentContextPhoto = context.object(with: _photoID) as! Photo
                let contextPin = context.object(with: _currentPinID) as! Pin
                
                if self.deleteIndexSet.contains(indexPath){
                    context.delete(currentContextPhoto)
                    contextPin.urlCount = contextPin.urlCount - 1
                    contextPin.photoCount = contextPin.photoCount - 1
                } else {
                    currentContextPhoto.index = newIndex
                    newIndex = newIndex + 1
                }
                try? context.save()
            }
        }
    }
    
    func stuff(){
        let queue = DispatchQueue(label: "com.company.app.queue", attributes: .concurrent)
        queue.async {
            self.removeSelectedPicture()
        }

        
        let dispatchWorkItem = DispatchWorkItem(qos: .default, flags: .barrier) {
            print("#3 finished")
//            DispatchQueue.main.async {
//                self.deleteIndexSet.removeAll()
//                self.loadCollectionArray()
//                self.myCollectionView.reloadData()
//            }
        }
        
        queue.async(execute: dispatchWorkItem)
    }

    
    @objc func handleNewLocationButton(_ sender: UIButton){
        if sender.isSelected {
            print("DELETE")
            stuff()
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
            }).resume()
        }
    }
    
    func deleteAllPhotosOnPin(_ pinToChange: Pin) {
        let fetch111 = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        fetch111.predicate = NSPredicate(format: "pin = %@", argumentArray: [pinToChange])
        let request = NSBatchDeleteRequest(fetchRequest: fetch111)
        _ = try? self.dataController.backGroundContext.execute(request)
        currentPin.urlCount = 0
        currentPin.photoCount = 0
        try? self.dataController.viewContext.save()
    }
}
