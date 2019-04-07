//
//  PinsMapController+MapKit.swift
//  __Virtual_Tourist
//
//  Created by admin on 4/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import MapKit

extension PinsMapController {
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        guard let selectedAnnotation = view.annotation as? CustomAnnotation, let desiredPin = getCorrespondingPin(annotation: selectedAnnotation) else {return}
//        //1
//        if tapDeletesPin {
//            dataController.viewContext.delete(desiredPin)
//            try? dataController.viewContext.save()
//            return
//        }
//        //2
//        PushToCollectionViewController(apin: desiredPin)
//    }
    
    func PushToCollectionViewController(apin: Pin){
        let nextController = CollectionMapViewsController()
//        newController.dataController = self.dataController
//        newController.pin = apin
//        self.delegate = newController
        print("lat/lon ---> \(apin.coordinate)")
        navigationController?.pushViewController(nextController, animated: true)
    }}
