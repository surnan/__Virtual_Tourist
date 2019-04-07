//
//  ViewController.swift
//  Virtual_Tourist
//
//  Created by admin on 4/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class PinsMapController: UIViewController {
    
    //MARK:- UI Constraints - CONSTANTS
    let bottomUILabelHeight: CGFloat = 70
    let defaultTitleFontSize: CGFloat = 22
    let defaultFontSize: CGFloat = 18
    
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        view.backgroundColor = UIColor.blue
    }
    
    
    @objc func handleEditButton(_ sender: UIButton){
        navigationController?.pushViewController(MapCollectionViewsController(), animated: true)
    }
    
    @objc func handleDeleteAllButton(_ sender: UIButton){
        navigationController?.pushViewController(MapCollectionViewsController(), animated: true)
    }
    
    
}

