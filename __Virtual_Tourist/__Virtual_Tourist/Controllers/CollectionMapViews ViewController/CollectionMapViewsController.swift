//
//  MapCollectionViewsController.swift
//  Virtual_Tourist
//
//  Created by admin on 4/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit
import CoreData



protocol CollectionMapViewControllerDelegate {
    func refreshCollectionView()
}


class CollectionMapViewsController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate, CollectionMapViewControllerDelegate, MKMapViewDelegate  {

    //MARK:- Injected Variables
    var currentPin: Pin!
    var dataController: DataController!
    
    //MARK:- Local Constants
    let reuseIdLoadingCell = "reuseIdLoadingCell"
    let reuseIDCellLoaded = "reuseIDCellLoaded"
    let reuseIDCellIsSelected = "reuseIDCellIsSelected"
    let mapRegionDistanceValue: CLLocationDistance = 2500
    let columnWidth: CGFloat = 10
    let rowHeight: CGFloat = 10
    
    //MARK:- Local Variables
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    let activityView: UIActivityIndicatorView = {
        let activityVC = UIActivityIndicatorView()
        activityVC.hidesWhenStopped = true
        activityVC.style = .gray
        activityVC.translatesAutoresizingMaskIntoConstraints = false
        return activityVC
    }()
    
    var screenBottomFiller: UIView = {
        //fill bottom of screen to bevel
        //newLocationButton.title will always be above bezel.
        let view = UIView()
        view.backgroundColor = UIColor.blue
        return view
    }()
    
    var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "This pin has no images"
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var photosArrayFetchCount = [Photo?](repeating: nil, count: fetchCount)
    var deleteIndexSet = Set<IndexPath>() {
        didSet {
            newLocationButton.isSelected = !deleteIndexSet.isEmpty
        }
    }
    
    //MARK:- Local Lazy Variables
    lazy var newLocationButton: UIButton = {
        let button = UIButton()
        button.setTitle("New Collection", for: .normal)
        button.backgroundColor = UIColor.blue
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Remove Selected Pictures", for: .selected)
        button.setTitleColor(UIColor.red, for: .selected)
        button.addTarget(self, action: #selector(handleNewLocationButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var customizedLayout: UICollectionViewFlowLayout = {
        let screenWidth = view.bounds.width                     //forces lazy
        let cellWidth = (screenWidth - columnWidth * 5) / 3
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: columnWidth, left: columnWidth, bottom: columnWidth, right: columnWidth)
        layout.itemSize = .init(width: cellWidth, height:   cellWidth)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = rowHeight
        layout.minimumInteritemSpacing = columnWidth
        return layout
    }()
    
    lazy var myCollectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: customizedLayout)
        collectionView.dataSource = self        //forces lazy
        collectionView.delegate = self
        collectionView.register(FinalCollectionLoadingCell.self, forCellWithReuseIdentifier: reuseIdLoadingCell)
        collectionView.register(FinalCollectionImageCell.self, forCellWithReuseIdentifier: reuseIDCellLoaded)
        collectionView.register(FinalCollectionSelectedImageCell.self, forCellWithReuseIdentifier: reuseIDCellIsSelected)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.allowsMultipleSelection = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var myMapView: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        map.isScrollEnabled = true
        map.isZoomEnabled = true
        map.mapType = .standard
        map.showsCompass = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    lazy var firstAnnotation: MKPointAnnotation = {
        let annotation = MKPointAnnotation()
        annotation.coordinate = currentPin.coordinate
        return annotation
    }()

    deinit {
        fetchedResultsController = nil
    }
}
