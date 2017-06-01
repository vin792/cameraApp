//
//  AlamofireService.swift
//  cameraTest
//
//  Created by Jordan Russell Weatherford on 5/31/17.
//  Copyright © 2017 Vineeth Raghunath. All rights reserved.
//

import Alamofire
import CoreLocation

class AlamofireService {
    typealias JSONStandard = [String : AnyObject]

//  MARK: - Get photos from server
    func getPhotos(userLocation: CLLocation){
        
        let parameters = ["latitude": userLocation.coordinate.latitude,
                          "longitude": userLocation.coordinate.longitude,
                          "altitude": userLocation.altitude]
        
        //post request to get data
        Alamofire.request("http://16bc29a0.ngrok.io/getPhotos", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(completionHandler: {
            response in
            
            if let JSON = response.result.value {
                print(JSON)
            }
            //self.parseJSON(JSONData: response.data!)
        })
    }
    
//  MARK: - Parse JSON
    func parseJSON(JSONData : Data){
        do {
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            print(readableJSON)
        } catch {
            print(error)
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
            
        }, to: "http://16bc29a0.ngrok.io/savePhoto") { (encodingResult) in }
    }
}
