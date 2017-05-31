//
//  MonocleViewController.swift
//  cameraTest
//
//  Created by Vineeth Raghunath on 5/30/17.
//  Copyright © 2017 Vineeth Raghunath. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MonocleViewController: UIViewController {
    
    //Variables
    let locationManager = CLLocationManager()
    var userLocation: CLLocation?
    var initialMapRegion: Bool = false
    
    //IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    //IBAction - display AR view
    @IBAction func showARController(_ sender: UIButton) {
        if userLocation != nil {
            print("\(userLocation)")
        } else {
            print("userLocation is nil")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
    }

}

extension MonocleViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            let location = locations.last!
            //print("latitude: \(location.coordinate.latitude), longitude: \(location.coordinate.longitude), altitude: \(location.altitude)")
            userLocation = location
            
            //Set initial mapView region
            if location.horizontalAccuracy < 100, !initialMapRegion {
                initialMapRegion = true
                let span = MKCoordinateSpanMake(0.014, 0.014)
                let region = MKCoordinateRegionMake(location.coordinate, span)
                mapView.region = region
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("hit the fail method")
    }
}


