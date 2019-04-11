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
    
    //MARK:- UI Constraints - CONSTANTS
    let bottomUILabelHeight: CGFloat = 70
    let defaultTitleFontSize: CGFloat = 22
    let defaultFontSize: CGFloat = 18
    
    //MARK:- UI Constraints - DYNAMIC
    var anchorMapTop_SafeAreaTop: NSLayoutConstraint?
    var anchorMapTop_ShiftMapToShowDeletionLabel: NSLayoutConstraint?
    var anchorMapBottom_ViewBottom: NSLayoutConstraint?
    var anchorMapBottom_ShiftMapToShowDeletionLabel: NSLayoutConstraint?
    
    //MARK:- Gestures
    lazy var myLongPressGesture: UILongPressGestureRecognizer = {
        var longGesture = UILongPressGestureRecognizer()
        longGesture.minimumPressDuration = 1
        longGesture.addTarget(self, action: #selector(handleLongPress(_:)))
        return longGesture
    }()
    
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

    
    var tapDeletesPin = false               //determines if deletionLabel is shown in UI
    var mapView = MKMapView()
    
    var myFetchController: NSFetchedResultsController<Pin>!
    var dataController: DataController!     //injected from AppDelegate
    var previousPinID: NSManagedObjectID?   //so we can retreive object prior to updating coordinates
    
    var delegate: CollectionMapViewControllerDelegate?
    var taskToGetPhotoURLs: URLSessionTask?
}

