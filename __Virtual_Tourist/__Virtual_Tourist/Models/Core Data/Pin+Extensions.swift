//
//  EXTENSIONS.swift
//  Virtual_Tourist
//
//  Created by admin on 3/4/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

extension Pin: MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        let latDegrees = CLLocationDegrees(latitude)
        let longDegrees = CLLocationDegrees(longitude)
        return CLLocationCoordinate2D(latitude: latDegrees, longitude: longDegrees)
    }

    public func movePin(coordinate: CLLocationCoordinate2D, viewContext: NSManagedObjectContext){
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.pageNumber = 1
        self.photoCount = 0
        self.urlCount = 0
        self.isDownloading = false
        try? viewContext.save()
    }

    //Executes at Pin Creation
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        pageNumber = 1
        photoCount = 0
        urlCount = 0
    }
}

extension Photo {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        isLoaded = false
    }
}

func connectPhotoAndPin(dataController: DataController, currentPin: Pin, data: Data, urlString: String, index: Int){
    let backgroundContext: NSManagedObjectContext! = dataController.backGroundContext
    let currentPinID = currentPin.objectID
    
    backgroundContext.perform {
        let backgroundPin = backgroundContext.object(with: currentPinID) as! Pin
        backgroundPin.photoCount = backgroundPin.photoCount + 1
        let tempPhoto = Photo(context: backgroundContext)
        tempPhoto.imageData = data
        tempPhoto.urlString = urlString
        tempPhoto.index = Int32(index) //Random value for init
        tempPhoto.pin = backgroundPin
        tempPhoto.isLoaded = true
        try? backgroundContext.save()
    }
}
