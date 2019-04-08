//
//  GetBulkPhotoResponse.swift
//  Virtual_Tourist
//
//  Created by admin on 2/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

//flickr.photos.search

struct PhotosSearch: Codable  {
    var photos: PhotosStruct
    var stat: String
    
    struct PhotosStruct: Codable {
        var page: Double
        var pages: Double
        var perpage: Double
        var total: String
        var photo: [PhotoStruct]
    }
    
    struct PhotoStruct: Codable {
        var id: String
        var owner: String
        var secret: String
        var server: String
        var farm: Double
        var title: String
        var ispublic: Double
        var isfriend: Double
        var isfamily: Double
    }
}

