//
//  MapController+CustomClasses.swift
//  Virtual_Tourist
//
//  Created by admin on 3/6/19.
//  Copyright © 2019 admin. All rights reserved.
//



import UIKit
import MapKit
import CoreData


class CustomAnnotationView: MKPinAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        pinTintColor = .black
        isDraggable = true
        animatesDrop = true
        canShowCallout = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class CustomAnnotation: NSObject, MKAnnotation {
    @objc dynamic var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(lat: Double, lon: Double, title: String? = nil, subtitle: String? = nil){
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        self.title = title
        self.subtitle = subtitle
        super.init()
    }
}
