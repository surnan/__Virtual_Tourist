//
//  ViewController.swift
//  Virtual_Tourist
//
//  Created by admin on 4/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PinsMapController: UIViewController, MKMapViewDelegate, NSFetchedResultsControllerDelegate {
    
    //MARK:- Injections from AppDelegate
    var dataController: DataController!     //injected from AppDelegate
    
    //MARK:- UI Constraints - CONSTANTS
    let bottomUILabelHeight: CGFloat = 70
    let defaultTitleFontSize: CGFloat = 22
    
    //MARK:- UI Constraints - DYNAMIC
    var anchorMapTop_SafeAreaTop: NSLayoutConstraint?
    var anchorMapTop_ShiftMapToShowDeletionLabel: NSLayoutConstraint?
    var anchorMapBottom_ViewBottom: NSLayoutConstraint?
    var anchorMapBottom_ShiftMapToShowDeletionLabel: NSLayoutConstraint?
    
    //MARK:- UI
    lazy var deletionLabel: UILabel = {
        var label = UILabel()
        label.backgroundColor = UIColor.red
        let attributes: [NSAttributedString.Key:Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: defaultTitleFontSize),
            NSAttributedString.Key.foregroundColor: UIColor.white]
        label.attributedText = NSAttributedString(string: "Tap Pins to Delete", attributes: attributes)
        label.textAlignment = .center
        label.heightAnchor.constraint(equalToConstant: bottomUILabelHeight).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK:- Gestures
    lazy var myLongPressGesture: UILongPressGestureRecognizer = {
        var longGesture = UILongPressGestureRecognizer()
        longGesture.minimumPressDuration = 1
        longGesture.addTarget(self, action: #selector(handleLongPress(_:)))
        return longGesture
    }()
    
    var mapView = MKMapView()
    var tapDeletesPin = false               //determines if deletionLabel is shown in UI
    
    var myFetchController: NSFetchedResultsController<Pin>!
    var previousPinID: NSManagedObjectID?   //To retreive object prior to changing Pin.coordinates
    var delegate: CollectionMapViewControllerDelegate?
    var downloadTask: URLSessionTask?
}

