//
//  AlamofireService.swift
//  cameraTest
//
//  Created by Jordan Russell Weatherford on 5/31/17.
//  Copyright © 2017 Vineeth Raghunath. All rights reserved.
//

import Alamofire
import CoreLocation
import HDAugmentedReality

class AlamofireService {
    typealias JSONStandard = [String : AnyObject]

//  MARK: - Get photos from server
    func getPhotos(userLocation: CLLocation, completionHandler: @escaping (Array<ARAnnotation>) -> ()){
        
        let parameters = ["latitude": userLocation.coordinate.latitude,
                          "longitude": userLocation.coordinate.longitude,
                          "altitude": userLocation.altitude]
        
        //post request to get data
        Alamofire.request("http://34.210.159.189/getPhotos", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(completionHandler: {
            response in
            
            var annotations = Array<ARAnnotation>()
            var responsePhotos = Array<Any>()
            var responseStatus: Bool = false
            
            if let JSON = response.result.value {
                if let data = JSON as? Dictionary<String, Any> {
                    for (key, value) in data {
                        if key == "status" {
                            responseStatus = value as! Bool
                        }
                        
                        if key == "photos" {
                            responsePhotos = value as! Array<Any>
                        }
                    }
                }
            }
            
            
            if responseStatus {
                for photo in responsePhotos {
                    let photoDict = photo as! Dictionary<String, Any>
                    
                    let latitude = photoDict["latitude"] as! CLLocationDegrees
                    let longitude  = photoDict["longitude"] as! CLLocationDegrees
                    let photoName = photoDict["_id"] as! String
                    let filePath = photoDict["location"] as! String
                    let username = photoDict["username"] as! String
                    
                    let location = CLLocation(latitude: latitude, longitude: longitude)
                    
                    let newARAnnotation = ARAnnotation(identifier: filePath, title: username, location: location)
                    
                    if let newARAnno = newARAnnotation {
                        annotations.append(newARAnno)
                    }
                }
            }
            
            completionHandler(annotations)
            
        })
    }
    
//  MARK: - gets3Image
    func getS3Image(fileLocation: String, completionHandler: @escaping (UIImage) -> ()){
        Alamofire.request(fileLocation).responseData { response in
            guard let data = response.result.value else { return }
            let s3Image = UIImage(data: data)
            completionHandler(s3Image!)
        }
        
    }
    
// MARK: - Send photo to server for storage
    func sendImageDataToServer(imageDataToSave: Dictionary<String, Any>){
        
        let photoData = imageDataToSave["photoData"] as! Data
        let latitude = "\(String(describing: imageDataToSave["latitude"]!))"
        let longitude = "\(String(describing: imageDataToSave["longitude"]!))"
        let altitude = "\(String(describing: imageDataToSave["altitude"]!))"
        let username = "\(String(describing: imageDataToSave["username"]!))"
        
        let parameters = [
            "latitude": latitude,
            "longitude": longitude,
            "altitude": altitude,
            "username": username]
        
        Alamofire.upload(multipartFormData: { multiPartFormData in
            
            multiPartFormData.append(photoData, withName: "photoData", fileName: "photo.jpg", mimeType: "image/jpeg")
            
            for (key, value) in parameters {
                multiPartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, to: "http://34.210.159.189/savePhoto") { (encodingResult) in print(encodingResult)}
    }
}
