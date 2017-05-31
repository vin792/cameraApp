//
//  AlamofireService.swift
//  cameraTest
//
//  Created by Jordan Russell Weatherford on 5/31/17.
//  Copyright © 2017 Vineeth Raghunath. All rights reserved.
//

import Alamofire

class AlamofireService {
    typealias JSONStandard = [String : AnyObject]

//    MARK: - Request from server
    func callAlamo(url : String){
        Alamofire.request(url).responseJSON(completionHandler: {
            response in
            self.parseJSON(JSONData: response.data!)
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
    func sendImageDataToServer(imageDataToSave : [String : String]){
        Alamofire.request("http://localhost:3000/dataFromUser", method: .post, parameters: imageDataToSave).responseJSON(completionHandler: {
            response in
            print(response)
        })
    }
}
