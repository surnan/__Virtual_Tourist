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
    
    @objc func handleNewLocationButton(_ sender: UIButton){
        if sender.isSelected {
            print("DELETE")
            deleteIndexSet.removeAll()
            myCollectionView.reloadData()
            

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
