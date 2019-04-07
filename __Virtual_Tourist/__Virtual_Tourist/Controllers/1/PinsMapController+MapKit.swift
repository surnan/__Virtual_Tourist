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
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let selectedAnnotation = view.annotation as? CustomAnnotation, let desiredPin = getCorrespondingPin(annotation: selectedAnnotation) else {return}

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
