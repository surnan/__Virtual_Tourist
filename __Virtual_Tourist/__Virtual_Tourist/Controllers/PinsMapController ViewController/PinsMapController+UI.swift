//
//  PinsMapController+UI.swift
//  __Virtual_Tourist
//
//  Created by admin on 4/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

import MapKit
import UIKit

extension PinsMapController {
    
    private func setupNavigationBar(){
        navigationItem.title = "Virtual Tourist"
        let editDoneButton: UIButton = {
            let button = UIButton()
            let attribEdit = NSAttributedString(string: "Edit", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
            let attribDone = NSAttributedString(string: "Done", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            button.setAttributedTitle(attribEdit, for: .normal)
            button.setAttributedTitle(attribDone, for: .selected)
            button.addTarget(self, action: #selector(handleEditButton), for: .touchUpInside)
            button.isSelected = false
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        let imageIcon = #imageLiteral(resourceName: "delete_84").withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editDoneButton)
        navigationItem.leftBarButtonItems = [UIBarButtonItem(image: imageIcon,
                                                             landscapeImagePhone: imageIcon,
                                                             style: .done,
                                                             target: self,
                                                             action: #selector(handleDeleteAllButton))]
    }
    

    private func setupUI(){
        setupNavigationBar()
        [mapView, deletionLabel].forEach{view.addSubview($0)}
        mapView.anchor(top: nil, leading: deletionLabel.leadingAnchor, trailing: deletionLabel.trailingAnchor, bottom: nil)
        deletionLabel.anchor(top: mapView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor,
                             trailing: view.safeAreaLayoutGuide.trailingAnchor, bottom: nil)
        anchorMapTop_SafeAreaTop =  mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        anchorMapTop_ShiftMapToShowDeletionLabel = mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -bottomUILabelHeight)
        anchorMapBottom_ViewBottom =  mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        anchorMapBottom_ShiftMapToShowDeletionLabel = mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomUILabelHeight)
        hideBottomlabel()
    }
    
    func toggleBottomUILabel(show: Bool){
        show ? showBottomlabel() : hideBottomlabel()
        UIView.animate(withDuration: 0.15,
                       animations: {self.view.layoutIfNeeded()},
                       completion: nil)
    }
    
    
//    var anchorMapTop_SafeAreaTop: NSLayoutConstraint?
//    var anchorMapTop_ShiftMapToShowDeletionLabel: NSLayoutConstraint?
//    var anchorMapBottom_ViewBottom: NSLayoutConstraint?
//    var anchorMapBottom_ShiftMapToShowDeletionLabel: NSLayoutConstraint?
    
    private func resetConstraintsOnBottomLabel(){
        anchorMapTop_SafeAreaTop?.isActive = false
        anchorMapTop_ShiftMapToShowDeletionLabel?.isActive = false
        anchorMapBottom_ViewBottom?.isActive = false
        anchorMapBottom_ShiftMapToShowDeletionLabel?.isActive = false
    }
    
    private func hideBottomlabel(){ //ViewDidLoad
        resetConstraintsOnBottomLabel()
        anchorMapTop_SafeAreaTop?.isActive = true
        anchorMapBottom_ViewBottom?.isActive = true
        tapDeletesPin = false
    }
    
    //Called by: func toggleBottomUILabel(show: Bool){..}
    private func showBottomlabel(){
        resetConstraintsOnBottomLabel()
        anchorMapTop_ShiftMapToShowDeletionLabel?.isActive = true
        anchorMapBottom_ShiftMapToShowDeletionLabel?.isActive = true
        tapDeletesPin = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        mapView.delegate = self
        mapView.addGestureRecognizer(myLongPressGesture)
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        setupUI()
        setupFetchController()
        myFetchController.delegate = self
        getAllPins().forEach{
            placeAnnotation(pin: $0)
        }
    }

    private func getAllPins()->[Pin]{
        return myFetchController.fetchedObjects ?? []
    }
    
    private func placeAnnotation(pin: Pin?) {
        guard let lat = pin?.latitude, let lon = pin?.longitude else {return}
        let myNewAnnotation = CustomAnnotation(lat: lat, lon: lon)
        mapView.addAnnotation(myNewAnnotation)
    }
}

