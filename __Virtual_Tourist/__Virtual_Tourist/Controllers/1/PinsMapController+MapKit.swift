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
    func placeAnnotation(pin: Pin?) {
        guard let lat = pin?.latitude, let lon = pin?.longitude else {return}
        let myNewAnnotation = CustomAnnotation(lat: lat, lon: lon)
        mapView.addAnnotation(myNewAnnotation)
    }
}
