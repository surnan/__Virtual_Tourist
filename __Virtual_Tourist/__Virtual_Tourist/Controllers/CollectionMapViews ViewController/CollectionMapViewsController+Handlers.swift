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
    
    private func removeSelectedPicture() {
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
                
                do {
                    try context.save()
                } catch let saveErr {
                    print("Error: Core Data Save Error when deleting selected picture.  removeSelectedPicture()\nCode: \(saveErr.localizedDescription)")
                    print("Full Error Details: \(saveErr)")
                }
            }
        }
    }
    
    @objc func handleNewLocationButton(_ sender: UIButton){
        if sender.isSelected {
            removeSelectedPicture()
        } else {
            deleteAllPhotosOnPin(currentPin)
            dataController.viewContext.perform { //1
                self.currentPin.pageNumber = self.currentPin.pageNumber + 1
                self.currentPin.photoCount = 0
                self.currentPin.isDownloading = true
                
                do {
                    try self.dataController.viewContext.save()
                } catch let saveErr {
                    print("Error: Core Data Save Error when reset Pin handleNewLocationButton(...)\nCode: \(saveErr.localizedDescription)")
                    print("Full Error Details: \(saveErr)")
                }
                
                DispatchQueue.main.async {
                    self.emptyLabel.isHidden = true
                    self.activityView.startAnimating()
                }
                
                _ = FlickrClient.getAllPhotoURLs(refresh: false, currentPin: self.currentPin, fetchCount: fetchCount, completion: self.handleGetAllPhotoURLs(pin:urls:error:))
            }
        }
    }
    
    
    func handleGetAllPhotoURLs(pin: Pin, urls: [URL], error: Error?){
        DispatchQueue.main.async {
            self.activityView.stopAnimating()
            if urls.isEmpty {
                self.emptyLabel.isHidden = false
            } else {
                self.emptyLabel.isHidden = true
            }
        }
        let backgroundContext: NSManagedObjectContext! = dataController.backGroundContext
        if let error = error {
            print("func mapView(_ mapView: MKMapView, didSelect... \n\(error)")
            showOKAlertController(title: "Network Error", message: "Unable to download photos")
            suppressAlerts = false  //Only need it suppressed when this function runs from ViewDidLoad
            return
        }
        let pinId = pin.objectID
        backgroundContext.perform {
            let backgroundPin = backgroundContext.object(with: pinId) as! Pin
            backgroundPin.urlCount = Int32(urls.count)
            backgroundPin.isDownloading = false
            
            do {
                try backgroundContext.save()
            } catch let saveErr {
                print("Error: Core Data Save Error within handleGetAllPhotoURLs(...)\nCode: \(saveErr.localizedDescription)")
                print("Full Error Details: \(saveErr)")
            }
        }
        for (index, currentURL) in urls.enumerated() {
            URLSession.shared.dataTask(with: currentURL, completionHandler: { (imageData, response, error) in
                guard let imageData = imageData else {return}
                connectPhotoAndPin(dataController: self.dataController, currentPin:  pin , data: imageData, urlString: currentURL.absoluteString, index: index)
            }).resume()
        }
    }
    
    
//    func handleGetAllPhotoURLs(pin: Pin, urls: [URL], error: Error?){
//        DispatchQueue.main.async {
//            self.activityView.stopAnimating()
//            if urls.isEmpty {
//                self.emptyLabel.isHidden = false
//            } else {
//                self.emptyLabel.isHidden = true
//            }
//        }
//        let backgroundContext: NSManagedObjectContext! = dataController.backGroundContext
//        if let error = error {
//            print("func mapView(_ mapView: MKMapView, didSelect... \n\(error)")
//            showOKAlertController(title: "Network Error", message: "Unable to download photos")
//
//
//            return
//        }
//        let pinId = pin.objectID
//        backgroundContext.perform {
//            let backgroundPin = backgroundContext.object(with: pinId) as! Pin
//            backgroundPin.urlCount = Int32(urls.count)
//            backgroundPin.isDownloading = false
//
//            do {
//                try backgroundContext.save()
//            } catch let saveErr {
//                print("Error: Core Data Save Error within handleGetAllPhotoURLs(...)\nCode: \(saveErr.localizedDescription)")
//                print("Full Error Details: \(saveErr)")
//            }
//        }
//        for (index, currentURL) in urls.enumerated() {
//            URLSession.shared.dataTask(with: currentURL, completionHandler: { (imageData, response, error) in
//                guard let imageData = imageData else {return}
//                connectPhotoAndPin(dataController: self.dataController, currentPin:  pin , data: imageData, urlString: currentURL.absoluteString, index: index)
//            }).resume()
//        }
//    }
    
    private func deleteAllPhotosOnPin(_ pinToChange: Pin) {
        let fetch111 = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        fetch111.predicate = NSPredicate(format: "pin = %@", argumentArray: [pinToChange])
        let request = NSBatchDeleteRequest(fetchRequest: fetch111)
        do {
            _ = try self.dataController.backGroundContext.execute(request)
        } catch let saveErr {
            print("Error: Core Data Save Error when deleting All Photos on Pin.  deleteAllPhotosOnPin(...)\nCode: \(saveErr.localizedDescription)")
            print("Full Error Details: \(saveErr)")
        }
        currentPin.urlCount = 0
        currentPin.photoCount = 0
        do {
            try self.dataController.viewContext.save()
        } catch let saveErr {
            print("Error: Core Data Save Error when deleting all photos on pin deleteAllPhotosOnPin(...)\nCode: \(saveErr.localizedDescription)")
            print("Full Error Details: \(saveErr)")
        }
    }
}
