//
//  PinsMapController+MapKit.swift
//  __Virtual_Tourist
//
//  Created by admin on 4/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import MapKit
import CoreData

extension PinsMapController {

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        guard let currentAnnotation = view.annotation else {return}
        switch (newState) {
        case .starting:
            view.dragState = .dragging
            if let view = view as? MKPinAnnotationView {
                view.pinTintColor = UIColor.green
            }
            previousPinID = getCorrespondingPin(annotation: currentAnnotation)?.objectID
        case .ending:
            view.dragState = .none
            cancelAllNetworkTask()
            if let view = view as? MKPinAnnotationView {
                view.pinTintColor = UIColor.black
            }
            guard let _previousPinID = previousPinID, let pinToChange = dataController.viewContext.object(with: _previousPinID) as? Pin else {return}
            deleteAllPhotosOnPin(pinToChange)
            pinToChange.movePin(coordinate: currentAnnotation.coordinate, viewContext: dataController.viewContext)
            
            dataController.viewContext.perform { //1
                pinToChange.pageNumber = 1
                pinToChange.photoCount = 0
                
                do {
                    try self.dataController.viewContext.save()
                } catch let saveErr {
                    print("Error: Core Data Save Error after pin is moved.  mapView(_ mapView: MKMapView(...)\nCode: \(saveErr.localizedDescription)")
                    print("Full Error Details: \(saveErr)")
                }
                
                self.downloadTask = FlickrClient.getAllPhotoURLs(refresh: false, currentPin: pinToChange, fetchCount: fetchCount, completion: self.handleGetAllPhotoURLs(pin:urls:error:))
            }
            
            previousPinID = nil
        case .canceling:
            if let view = view as? MKPinAnnotationView {view.pinTintColor = UIColor.black}
        default: break
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let selectedAnnotation = view.annotation as? CustomAnnotation,
            let desiredPin = getCorrespondingPin(annotation: selectedAnnotation) else {return}

        if tapDeletesPin {
            dataController.viewContext.perform {
                self.dataController.viewContext.delete(desiredPin)
                
                do {
                    try self.dataController.viewContext.save()
                } catch let saveErr {
                    print("Error: Core Data Save Error when deleting selected annotation/pin.  mapView(_ mapView(...)\nCode: \(saveErr.localizedDescription)")
                    print("Full Error Details: \(saveErr)")
                }
                return
            }
        } else {
            PushToCollectionViewController(apin: desiredPin)
        }
    }
    
    private func deleteAllPhotosOnPin(_ pinToChange: Pin) {
        let fetchPhotoController = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        fetchPhotoController.predicate = NSPredicate(format: "pin = %@", argumentArray: [pinToChange])
        let request = NSBatchDeleteRequest(fetchRequest: fetchPhotoController)
        
        do {
            _ = try self.dataController.backGroundContext.execute(request)
            try self.dataController.viewContext.save()
        } catch let saveErr {
            print("Error: Core Data Save Error when deleting All Photos on Pin.  deleteAllPhotosOnPin(...)\nCode: \(saveErr.localizedDescription)")
            print("Full Error Details: \(saveErr)")
        }
    }
    
    private func PushToCollectionViewController(apin: Pin){
        let nextController = CollectionMapViewsController()
        nextController.dataController = self.dataController
        nextController.currentPin = apin
        nextController.downloadTask = downloadTask
        delegate = nextController
        navigationController?.pushViewController(nextController, animated: true)
    }
    
    private func getCorrespondingPin(annotation: MKAnnotation) -> Pin?{
        let location = annotation.coordinate
        let context = dataController.viewContext
        let fetchRequest = NSFetchRequest<Pin>(entityName: "Pin")
        let predicate = NSPredicate(format: "(latitude = %@) AND (longitude = %@)", argumentArray: [location.latitude, location.longitude])
        fetchRequest.predicate = predicate
        do {
            let result = try context.fetch(fetchRequest)
            return result.first
        } catch {
            return nil
        }
    }
    
    private func getCorrespondingPin(coordinate: CLLocationCoordinate2D) -> Pin?{
        let location = coordinate
        let context = dataController.viewContext
        let fetchRequest = NSFetchRequest<Pin>(entityName: "Pin")
        let predicate = NSPredicate(format: "(latitude = %@) AND (longitude = %@)", argumentArray: [location.latitude, location.longitude])
        fetchRequest.predicate = predicate
        do {
            let result = try context.fetch(fetchRequest)
            return result.first
        } catch {
            return nil
        }
    }
    
    
    // MARK: - Canceling network task
    private func cancelAllNetworkTask() {
        URLSession.shared.getAllTasks(completionHandler: { (tasks) -> Void in
            for task in tasks {
                task.cancel()
            }
        })
    }
}
