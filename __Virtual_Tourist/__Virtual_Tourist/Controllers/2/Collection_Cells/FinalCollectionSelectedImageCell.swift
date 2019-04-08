//
//  CollectionCell3.swift
//  Virtual_Tourist
//
//  Created by admin on 3/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

class FinalCollectionSelectedImageCell: UICollectionViewCell {
    
    var myPhoto: Photo! {
        didSet {
            if let myImageData = myPhoto.imageData, let myImage = UIImage(data: myImageData) {
                myImageView.image = myImage
            }
        }
    }
    
    var myImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.alpha = 0.15
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(myImageView)
        myImageView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



