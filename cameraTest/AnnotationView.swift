//
//  AnnotationView.swift
//  cameraTest
//
//  Created by Jordan Russell Weatherford on 6/1/17.
//  Copyright © 2017 Vineeth Raghunath. All rights reserved.
//

import UIKit
import HDAugmentedReality

protocol AnnotationViewDelegate {
    func didTouch(annotationView: AnnotationView)
}

class AnnotationView: ARAnnotationView {
    var distanceLabel: UILabel?
    var image: UIImageView?
    var delegate: AnnotationViewDelegate?
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        loadUI()
    }
    
    func loadUI() {
        
        let alamofire = AlamofireService()
        
        image = UIImageView(frame: CGRect(x: 10, y: 30, width: 135, height: 240))
        image?.layer.borderColor = UIColor.black.cgColor
        image?.layer.borderWidth = 1
        
        alamofire.getS3Image(fileLocation: (annotation?.identifier)!, completionHandler: {s3Image in
            
            self.image?.image = s3Image
            self.addSubview(self.image!)
            
            self.distanceLabel?.removeFromSuperview()
            self.distanceLabel = UILabel(frame: CGRect(x: 10, y: 30, width: 135, height: 20))
            self.distanceLabel?.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
            self.distanceLabel?.textColor = UIColor.green
            self.distanceLabel?.font = UIFont.systemFont(ofSize: 12)
            self.addSubview(self.distanceLabel!)
            
            if let annotation = self.annotation {
                self.distanceLabel?.text = String(format: "%.2f km", annotation.distanceFromUser / 1000)
            }
            
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        image?.frame = CGRect(x: 10, y: 30, width: 135, height: 240)
        distanceLabel?.frame = CGRect(x: 10, y: 30, width: 135, height: 20)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didTouch(annotationView: self)
    }
}
