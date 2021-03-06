//
//  FlickrClient.swift
//  __Virtual_Tourist
//
//  Created by admin on 4/8/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation


class FlickrClient {
    
    private enum Endpoints {
        static let base = "https://api.flickr.com/services/rest/?"
        case photosSearch(Double, Double, Int, Int32)   //Int32 because Int isn't CoreData type
        case getOnePicture(String , String)
        case getPhotosGetSizes(String)
        
        var toString: String {
            switch self {
            case .photosSearch(let latitude, let longitude, let maxPull, let page): return Endpoints.base
                + "method=flickr.photos.search"
                + "&api_key=\(API_KEY)"
                + "&lat=\(latitude)"
                + "&lon=\(longitude)"
                + "&per_page=\(maxPull)"
                + "&page=\(page)"
                + "&format=json"
                + "&nojsoncallback=1"
            case .getOnePicture(let photoID, let secret): return Endpoints.base
                + "method=flickr.photos.getInfo"
                + "&api_key=\(API_KEY)"
                + "&photo_id=\(photoID)"
                + "&secret=\(secret)"
                + "&format=json"
                + "&nojsoncallback=1"
            case .getPhotosGetSizes(let photo_id): return Endpoints.base
                + "method=flickr.photos.getSizes"
                + "&api_key=\(API_KEY)"
                + "&photo_id=\(photo_id)"
                + "&format=json"
                + "&nojsoncallback=1"
            }
        }
        var url: URL {
            return URL(string: toString)!
        }
    }
    
    class func getAllPhotoURLs(refresh: Bool, currentPin: Pin, fetchCount count: Int, completion: @escaping (Pin, [URL], Error?)->Void)-> URLSessionTask?{
        let latitude = currentPin.latitude
        let longitude = currentPin.longitude
        var pageNumber = currentPin.pageNumber
        
        //refresh means to call the same page.  Not the page+1 that is saved to currentPin
        if refresh {
            pageNumber = pageNumber - 1
        }
        
        let url = Endpoints.photosSearch(latitude, longitude, count, pageNumber).url
        var arrayPhotoURLs = [URL]()
        var arrayPhotoIdSecret = [[String: String]]()
        var arrayUrlStrings = [String]()
        var arrayFlickrUrlStrings = [String]()
        var count = 0
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let dataObject = data, error == nil else {
                DispatchQueue.main.async {
                    completion(currentPin, [], error)
                }
                return
            }
            do {
                let temp = try JSONDecoder().decode(PhotosSearch.self, from: dataObject)
                if temp.photos.photo.isEmpty == false {
                    temp.photos.photo.forEach {
                        let tempDict = [$0.id : $0.secret]
                        arrayPhotoIdSecret.append(tempDict)
                        
                        let photoURL = FlickrClient.Endpoints.getOnePicture($0.id, $0.secret)
                        let photoURLString = photoURL.toString
                        arrayUrlStrings.append(photoURLString)
                        
                        getPhotoURL(photoID: $0.id, secret: $0.secret, completion: { (urlString, error) in
                            guard let urlString = urlString else {return}
                            arrayFlickrUrlStrings.append(urlString)
                            arrayPhotoURLs.append(URL(string: urlString)!)
                            count = count + 1
                            if count == temp.photos.photo.count {
                                DispatchQueue.main.async {
                                    completion(currentPin, arrayPhotoURLs, nil)
                                }
                            }
                        })
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(currentPin, [], nil)
                    }
                }
            } catch let conversionErr {
                DispatchQueue.main.async {
                    completion(currentPin, [], conversionErr)
                }
                return
            }
        }
        task.resume()
        return task
    }
    
    private class func getPhotoURL(photoID: String, secret: String, completion: @escaping (String?, Error?)->Void){
        let url = Endpoints.getOnePicture(photoID, secret).url
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let dataObject = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do {
                let temp = try JSONDecoder().decode(PhotosGetInfo.self, from: dataObject)
                DispatchQueue.main.async {
                    let urlString = "https://farm\(temp.photo.farm).staticflickr.com/\(temp.photo.server)/\(temp.photo.id)_\(temp.photo.secret)_m.jpg"
                    completion(urlString, nil)
                }
                return
            } catch let conversionErr {
                DispatchQueue.main.async {
                    completion(nil, conversionErr)
                }
                return
            }
        }
        task.resume()
    }
}
