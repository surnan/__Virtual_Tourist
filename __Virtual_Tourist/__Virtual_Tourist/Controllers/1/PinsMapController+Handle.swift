//
//  PinsMapController+Handle.swift
//  __Virtual_Tourist
//
//  Created by admin on 4/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit
import CoreData

extension PinsMapController {
    @objc func handleEditButton(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
        toggleBottomUILabel(show: sender.isSelected)
    }
    
    @objc func handleDeleteAllButton(_ sender: UIButton){
        mapView.removeAnnotations(mapView.annotations)
        do {
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
            let request = NSBatchDeleteRequest(fetchRequest: fetch)
            try dataController.backGroundContext.execute(request)
            try dataController.backGroundContext.save()
        } catch {
            print ("There was an error when trying to delete all Pins on Map")
        }
    }
    
 
    
    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer){
        print("handle -1")
        if sender.state != .ended {
            print("handle -2")
            let touchLocation = sender.location(in: self.mapView)
            let locationCoordinate = self.mapView.convert(touchLocation,toCoordinateFrom: self.mapView)

            

            dataController.viewContext.perform { //1
                print("handle -3")
                let pinToAdd = Pin(context: self.dataController.viewContext) //moving above 1 causes pin not drop
                pinToAdd.latitude = locationCoordinate.latitude
                pinToAdd.longitude = locationCoordinate.longitude
                pinToAdd.pageNumber = 1
                pinToAdd.photoCount = 0
                try? self.dataController.viewContext.save()
                self.taskToGetPhotoURLs = FlickrClient.getAllPhotoURLs(currentPin: pinToAdd, fetchCount: fetchCount, completion: self.handleGetAllPhotoURLs(pin:urls:error:))
            }
        }
    }
    
    
    func handleGetAllPhotoURLs(pin: Pin, urls: [URL], error: Error?){
        let backgroundContext: NSManagedObjectContext! = dataController.backGroundContext
        
        if let error = error {
            print("error.localizedDescription --> \(error.localizedDescription)")
            print("...func mapView(_ mapView: MKMapView, didSelect... \n\(error)")
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
    
    
    
    
    
}
