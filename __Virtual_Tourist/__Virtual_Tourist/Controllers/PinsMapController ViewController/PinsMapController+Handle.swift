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
        if mapView.annotations.isEmpty {
            showAlertController(title: "Delete All Pins Cancelled", message: "No Pins on Map to Delete")
        } else {
            showAlertController(title: "Confirmation Needed", message: "Please confirm deletion of all pins") {[unowned self] (_) in
                self.mapView.removeAnnotations(self.mapView.annotations)
                do {
                    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
                    let request = NSBatchDeleteRequest(fetchRequest: fetch)
                    try self.dataController.backGroundContext.execute(request)
                    try self.dataController.backGroundContext.save()
                } catch {
                    print ("There was an error when trying to delete all Pins on Map")
                }
            }
        }
    }
    
    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer){
        if sender.state != .ended {
            let touchLocation = sender.location(in: self.mapView)
            let locationCoordinate = self.mapView.convert(touchLocation,toCoordinateFrom: self.mapView)
            dataController.viewContext.perform { //1
                let pinToAdd = Pin(context: self.dataController.viewContext) //moving above 1 and no pin drop
                pinToAdd.latitude = locationCoordinate.latitude
                pinToAdd.longitude = locationCoordinate.longitude
                pinToAdd.pageNumber = 1
                pinToAdd.photoCount = 0
                pinToAdd.isDownloading = true
                do {
                    try self.dataController.viewContext.save()
                } catch let saveErr {
                    print("Error: Core Data Save Error when adding New Pin.  handleLongPress(...)\nCode: \(saveErr.localizedDescription)")
                    print("Full Error Details: \(saveErr)")
                }
                self.downloadTask = FlickrClient.getAllPhotoURLs(refresh: false, currentPin: pinToAdd, fetchCount: fetchCount, completion: self.handleGetAllPhotoURLs(pin:urls:error:))
            }
        }
    }
    
    
    func handleGetAllPhotoURLs(pin: Pin, urls: [URL], error: Error?){
        if let error = error {
            showAlertController(title: "Network Error", message: "Unable to download photos")
            print("error.localizedDescription --> \(error.localizedDescription)")
            print("...func mapView(_ mapView: MKMapView, didSelect... \n\(error)")
            return
        }
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("pinDownloadNetworkRequestCompleteObserver"), object: nil)
        let pinId = pin.objectID
        let backgroundContext: NSManagedObjectContext! = dataController.backGroundContext
        backgroundContext.perform {
            let backgroundPin = backgroundContext.object(with: pinId) as! Pin
            backgroundPin.isDownloading = false
            backgroundPin.urlCount = Int32(urls.count)
            do {
                try backgroundContext.save()
            } catch let saveErr {
                print("Error: Core Data Save Error when updating Pin after all photos downloaded.  handleGetAllPhotoURLs(...)\nCode: \(saveErr.localizedDescription)")
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
}
