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
    
    
    lazy var myMapView: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        map.isScrollEnabled = true
        map.isZoomEnabled = true
        map.mapType = .standard
        map.showsCompass = true //not working on simulator
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    //MARK:- Code Starts Here
    override func viewDidLoad() {
        view.backgroundColor = UIColor.yellow
        print("CollectionView ... Pin \(currentPin.coordinate)")
        setupFetchedResultsController()
        setupUI()
    }
    
    var temp = [Photo?](repeating: nil, count: fetchCount)

    
    func setupUI(){
        
        [myMapView, myCollectionView].forEach{view.addSubview($0)}
        
        let safe = view.safeAreaLayoutGuide
        myMapView.anchor(top: safe.topAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor)
        myMapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25).isActive = true
        myCollectionView.anchor(top: myMapView.bottomAnchor, leading: myMapView.leadingAnchor, trailing: myMapView.trailingAnchor, bottom:
            view.safeAreaLayoutGuide.bottomAnchor)
//        newLocationButton.anchor(leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: safe.bottomAnchor)
//        screenBottomFiller.anchor(top: newLocationButton.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor)
//        emptyCollectionStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        emptyCollectionStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
//    func fetchData(){
//        onlyDateArr.removeAll()
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PhotoData")
//        do {
//            let results = try context.fetch(fetchRequest)
//            let  dateCreated = results as! [PhotoData]
//
//            for _datecreated in dateCreated {
//                print(_datecreated.dateCreation!)
//                onlyDateArr.append(_datecreated)
//            }
//        }catch let err as NSError {
//            print(err.debugDescription)
//        }
//    }
}


struct PhotoElementForCollectionView {
    var index: IndexPath
    var photo: Photo
}

extension Array where Element : Photo {
    func hello(){
        print("Hello World")
    }
}
