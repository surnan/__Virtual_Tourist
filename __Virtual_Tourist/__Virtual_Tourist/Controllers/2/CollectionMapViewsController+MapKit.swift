//
//  CollectionMapViewsController+MapKit.swift
//  __Virtual_Tourist
//
//  Created by admin on 4/8/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import MapKit
import CoreData

extension CollectionMapViewsController {

    func setupMapView() {
        myMapView.addAnnotation(firstAnnotation)
        myMapView.centerCoordinate = firstAnnotation.coordinate
        //Setting up Zoom
        let noLocation = firstAnnotation.coordinate
        let viewRegion = MKCoordinateRegion(center: noLocation, latitudinalMeters: mapRegionDistanceValue, longitudinalMeters: mapRegionDistanceValue)
        myMapView.setRegion(viewRegion, animated: false)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.displayPriority = .defaultHigh
            pinView!.canShowCallout = true
            pinView!.tintColor = .blue
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }

}
