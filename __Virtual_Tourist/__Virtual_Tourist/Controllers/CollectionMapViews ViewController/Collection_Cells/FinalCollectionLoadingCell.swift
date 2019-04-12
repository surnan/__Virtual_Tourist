//
//  MyCollectionCell.swift
//  Loading Screen Test
//
//  Created by admin on 3/9/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class FinalCollectionLoadingCell:UICollectionViewCell{
    
    let activityBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let myActivityIndicatorView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView()
        activityView.style = .whiteLarge
        activityView.startAnimating()
        activityView.translatesAutoresizingMaskIntoConstraints = false
        return activityView
    }()
    
    let cellBackGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(cellBackGroundView)

        [myActivityIndicatorView, activityBackgroundView].forEach{cellBackGroundView.insertSubview($0, at: 0)}
        cellBackGroundView.fillSuperview()
        activityBackgroundView.fillSuperview()
        myActivityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        myActivityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        //restarts animation when cell is refreshed
        super.prepareForReuse()
        self.myActivityIndicatorView.startAnimating()
    }
}
