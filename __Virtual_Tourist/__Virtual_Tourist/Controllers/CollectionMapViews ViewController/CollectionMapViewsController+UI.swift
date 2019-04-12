//
//  CollectionMapViewsController+UI.swift
//  __Virtual_Tourist
//
//  Created by admin on 4/11/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit
import CoreData

extension CollectionMapViewsController {
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        setupFetchedResultsController()
        loadCollectionArray()
        setupUI()
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(pinDownloadNetworkRequestCompleteObserver), name: Notification.Name("pinDownloadNetworkRequestCompleteObserver"), object: nil)
        
        if (currentPin.urlCount == 0){
            activityView.startAnimating()
            _ = FlickrClient.getAllPhotoURLs(refresh: true, currentPin: self.currentPin, fetchCount: fetchCount, completion: self.handleGetAllPhotoURLs(pin:urls:error:))
        }
    }
    
    @objc private func pinDownloadNetworkRequestCompleteObserver(){
        print("notification received")
        activityView.stopAnimating()
    }
    
    func loadCollectionArray(){
        photosArrayFetchCount.removeAll()
        photosArrayFetchCount = [Photo?](repeating: nil, count: fetchCount)
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", argumentArray: [currentPin])
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "index", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var results: [Photo]?
        do {
            results = try dataController.backGroundContext.fetch(fetchRequest)
            guard let _results = results else {
                print("Unable to unwrap 'results'")
                return
            }
            _results.forEach { (currentPhoto) in
                let destIndex = Int(currentPhoto.index)
                photosArrayFetchCount[destIndex] = currentPhoto
            }
        } catch let fetchErr {
            print("Error fetching photos to load CollectionViewArray  loadCollectionArray()\nCode: \(fetchErr.localizedDescription)")
            print("Full Error Details: \(fetchErr)")
        }
    }
    
    private func setupUI(){
        [myMapView, myCollectionView, newLocationButton, activityView, screenBottomFiller, emptyLabel, buttonBlockLabelView].forEach{view.addSubview($0)}
        let safe = view.safeAreaLayoutGuide
        myMapView.anchor(top: safe.topAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor)
        myMapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25).isActive = true
        myCollectionView.anchor(top: myMapView.bottomAnchor, leading: myMapView.leadingAnchor,
                                trailing: myMapView.trailingAnchor, bottom: newLocationButton.topAnchor)
        newLocationButton.anchor(leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: safe.bottomAnchor)
        buttonBlockLabelView.anchor(top: newLocationButton.topAnchor ,leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: safe.bottomAnchor)
        screenBottomFiller.anchor(top: newLocationButton.bottomAnchor, leading: view.leadingAnchor,
                                  trailing: view.trailingAnchor, bottom: view.bottomAnchor)
        activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        hideEmptyLabelWhileDownloading()
        showActivityViewWhileDownloadingPins()
        setupMapView()
        setupNavigationMenu()
    }
    
    
    private func hideEmptyLabelWhileDownloading(){
        //If there are no CollectionViewCells but network request to download pins is still active
        //don't show empty message label
        if !currentPin.isDownloading {
            emptyLabel.isHidden = currentPin.urlCount == 0 ? false : true
        }
    }
    
    private func showActivityViewWhileDownloadingPins(){
        //If network request to download pins is active, start ActivityView.
        //The activity view will be stopped via Notification Center
        if downloadTask != nil && (downloadTask.state == URLSessionTask.State.running) {
            activityView.startAnimating()
            buttonBlockLabelView.isHidden = false
        }
    }
    
    private func setupNavigationMenu(){
        navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "⏎ OK", style: .done, target: self, action: #selector(handleBack))]
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "noun_Pin_2362323_000000"), style: .plain, target: self, action: #selector(handleReCenter))
    }
    
    @objc private func handleReCenter(){
        myMapView.centerCoordinate = firstAnnotation.coordinate
    }
    
    @objc private func handleBack(){
        navigationController?.popViewController(animated: true)
    }
}
