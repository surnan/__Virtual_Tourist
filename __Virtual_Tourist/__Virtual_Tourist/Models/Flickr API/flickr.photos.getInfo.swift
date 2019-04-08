//
//  getOnePictureResponse.swift
//  Virtual_Tourist
//
//  Created by admin on 2/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

//flickr.photos.getInfo

struct PhotosGetInfo: Codable {
    var photo: PhotoStruct
    var stat: String
    
    
    struct PhotoStruct: Codable {
        var id: String
        var secret: String
        var server: String
        var farm: Int
//        var dateuploaded: String
//        var isfavorite: Double?
//        var license: String?
//        var safety_level: String?
//        var rotation: Double?
//        var originalsecret: String?
//        var originalformat: String?
//        var views: String
//        var media: String
//        var title: [String:String]
//        var description: [String: String]
//        var visibility: [String: Double]
//        var dates: [String: String]
//        var editability: [String: Double]
//        var publiceditability: [String: Double]
//        var usage: [String: Double]
//        var comments: [String: String]
//        var notes: [String: [String]]
//        var people: [String: Double]
//        var geoperms: [String: Double]
//        var tags: [String: [TagStruct]]
//        var location: LocationStruct
//        var owner: OwnerStruct
//        var urls: URLSStruct    // +++++++
    }
    
    struct TagStruct: Codable {
        var id: String
        var author: String
        var raw: String
        var _content: String
        var machine_tag: Int
    }
    
    struct LocationStruct: Codable {
        var latitude: String
        var longitude: String
        var accuracy: String?
        var context: String?
        var county: [String: String]?
        var region: [String: String]?
        var country: [String: String]?
        var place_id: String?
        var woeid: String?
    }
    
    struct OwnerStruct: Codable {
        var nsid: String
        var username: String
        var realname: String
        var location: String
        var iconserver: String
        var iconfarm: Double
        var path_alias: String?
    }
    
    struct URLStruct: Codable {
        var type: String
//        var _content: String
        var _content: URL
    }
    
    struct URLSStruct: Codable {
        var url: [URLStruct]
    }
}
