//
//  flickr.photos.getSizes.swift
//  Virtual_Tourist
//
//  Created by admin on 3/2/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

//struct PhotosGetInfo: Codable
struct PhotosGetSizes: Codable {
    let sizes: Sizes
    let stat: String
}

struct Sizes: Codable {
    let canblog, canprint, candownload: Int
    let size: [Size]
}

struct Size: Codable {
    let label,media,source: String
    let width, String_or_INT: String_or_INT
    let url:URL
}

enum String_or_INT: Codable {
    case integer(Int)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(String_or_INT.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for String_or_INT"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

