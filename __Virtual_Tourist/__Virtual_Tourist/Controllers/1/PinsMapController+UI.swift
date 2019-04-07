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
    func setupNavigationBar(){
        navigationItem.title = "Virtual Tourist"
        let editDoneButton: UIButton = {
            let button = UIButton()
            button.setTitle("Edit", for: .normal)
            button.setTitleColor(UIColor.blue, for: .normal)
            button.setAttributedTitle(NSAttributedString(string: "Done", attributes: [NSAttributedString.Key.font :  UIFont.systemFont(ofSize: defaultFontSize)]), for: .selected)
            button.setTitle("Done", for: .selected)
            button.addTarget(self, action: #selector(handleEditButton), for: .touchUpInside)
            button.isSelected = false
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editDoneButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Delete ALL", style: .done, target: self, action: #selector(handleDeleteAllButton))
        
    }
    
    func setupUI(){
        setupNavigationBar()
        [mapView, deletionLabel].forEach{view.addSubview($0)}
        mapView.anchor(top: nil, leading: deletionLabel.leadingAnchor, trailing: deletionLabel.trailingAnchor, bottom: nil)
        deletionLabel.anchor(top: mapView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, bottom: nil)
        
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
    
    func resetConstraintsOnBottomLabel(){
        anchorMapTop_SafeAreaTop?.isActive = false
        anchorMapTop_ShiftMapToShowDeletionLabel?.isActive = false
        anchorMapBottom_ViewBottom?.isActive = false
        anchorMapBottom_ShiftMapToShowDeletionLabel?.isActive = false
    }
    
    func hideBottomlabel(){ //ViewDidLoad
        resetConstraintsOnBottomLabel()
        anchorMapTop_SafeAreaTop?.isActive = true
        anchorMapBottom_ViewBottom?.isActive = true
        tapDeletesPin = false
    }
    
    //Called by: func toggleBottomUILabel(show: Bool){..}
    func showBottomlabel(){
        resetConstraintsOnBottomLabel()
        anchorMapTop_ShiftMapToShowDeletionLabel?.isActive = true
        anchorMapBottom_ShiftMapToShowDeletionLabel?.isActive = true
        tapDeletesPin = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
//        self.addSaveNotifcationObserver()
        mapView.delegate = self
        mapView.addGestureRecognizer(myLongPressGesture)
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        setupUI()
        
//        setupFetchController()
//        myFetchController.delegate = self
//        getAllPins().forEach{
//            placeAnnotation(pin: $0)
//        }
        
    }
}
