//
//  PinsMapController+Handle.swift
//  __Virtual_Tourist
//
//  Created by admin on 4/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension PinsMapController {
    @objc func handleEditButton(_ sender: UIButton){
//        navigationController?.pushViewController(MapCollectionViewsController(), animated: true)
        sender.isSelected = !sender.isSelected
        toggleBottomUILabel(show: sender.isSelected)
    }
    
    @objc func handleDeleteAllButton(_ sender: UIButton){
        navigationController?.pushViewController(MapCollectionViewsController(), animated: true)
    }
    
    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer){
        print("LONG PRESS")
    }
    
    

    
}
