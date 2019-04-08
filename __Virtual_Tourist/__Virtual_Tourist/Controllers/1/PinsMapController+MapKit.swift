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
            if let view = view as? MKPinAnnotationView {
                view.pinTintColor = UIColor.black
            }
            guard let _previousPinID = previousPinID, let pinToChange = dataController.viewContext.object(with: _previousPinID) as? Pin else {return}
            deleteAllPhotosOnPin(pinToChange)
            pinToChange.movePin(coordinate: currentAnnotation.coordinate, viewContext: dataController.viewContext)
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
                try? self.dataController.viewContext.save()
                return
            }
        } else {
            PushToCollectionViewController(apin: desiredPin)
        }
    }
    
    func deleteAllPhotosOnPin(_ pinToChange: Pin) {
        let fetch111 = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        fetch111.predicate = NSPredicate(format: "pin = %@", argumentArray: [pinToChange])
        let request = NSBatchDeleteRequest(fetchRequest: fetch111)
        _ = try? self.dataController.backGroundContext.execute(request)
        try? self.dataController.viewContext.save()
    }
    
    func PushToCollectionViewController(apin: Pin){
        let nextController = CollectionMapViewsController()
        nextController.dataController = self.dataController
        nextController.currentPin = apin
        // self.delegate = nextController
        print("lat/lon ---> \(apin.coordinate)")
        navigationController?.pushViewController(nextController, animated: true)
    }
    
    func getCorrespondingPin(annotation: MKAnnotation) -> Pin?{
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
    
    func getCorrespondingPin(coordinate: CLLocationCoordinate2D) -> Pin?{
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
}
