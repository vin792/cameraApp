//
//  DisplayFullPhotoViewController.swift
//  cameraTest
//
//  Created by Vineeth Raghunath on 6/1/17.
//  Copyright © 2017 Vineeth Raghunath. All rights reserved.
//

import UIKit

class DisplayFullPhotoViewController: UIViewController {
    
    //Variables
    var imageToDisplay: UIImage?
    
    //IBOutlets
    @IBOutlet weak var fullPhotoImageView: UIImageView!
    
    //IBAction - close view
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullPhotoImageView.image = imageToDisplay
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
