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
    func refresh()
}


class CollectionMapViewsController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,NSFetchedResultsControllerDelegate, CollectionMapViewControllerDelegate, MKMapViewDelegate  {

    //MARK:- Injected Variables
    var currentPin: Pin!   //injected from MapController
    var dataController: DataController! //injected from MapController
    
    //MARK:- Local Variables
    let reuseIdLoadingCell = "reuseIdLoadingCell"
    let reuseIDCellLoaded = "reuseIDCellLoaded"
    let reuseIDCellIsSelected = "reuseIDCellIsSelected"
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    
    
    //MARK:- Lazy Local Variables
    lazy var customizedLayout: UICollectionViewFlowLayout = {
        let columnWidth: CGFloat = 10; let rowHeight: CGFloat = 10
        let screenWidth = view.bounds.width
        let cellWidth = (screenWidth - 60) / 3
        let cellWidth2 = (screenWidth - columnWidth * 5) / 3
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: columnWidth, left: columnWidth, bottom: columnWidth, right: columnWidth)
        layout.itemSize = .init(width: cellWidth2, height:   cellWidth2)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = rowHeight
        layout.minimumInteritemSpacing = columnWidth
        return layout
    }()
    
    lazy var myCollectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: customizedLayout)
        collectionView.dataSource = self
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
    
    
    //MARK:- Code Starts Here
    override func viewDidLoad() {
        view.backgroundColor = UIColor.yellow
        print("CollectionView ... Pin \(currentPin.coordinate)")
        setupFetchedResultsController()
    }
}


