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
//        navigationController?.pushViewController(MapCollectionViewsController(), animated: true)
        sender.isSelected = !sender.isSelected
        toggleBottomUILabel(show: sender.isSelected)
    }
    
    @objc func handleDeleteAllButton(_ sender: UIButton){
        mapView.removeAnnotations(mapView.annotations)
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
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
            
            dataController.viewContext.perform {
                print("handle -3")
                let pinToAdd = Pin(context: self.dataController.viewContext)
                pinToAdd.latitude = locationCoordinate.latitude
                pinToAdd.longitude = locationCoordinate.longitude
                pinToAdd.pageNumber = 1
                pinToAdd.photoCount = 0
                try? self.dataController.viewContext.save()
            }
        }
    }
}
