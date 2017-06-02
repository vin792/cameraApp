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
import HDAugmentedReality

class MonocleViewController: UIViewController {
    
    //Variables
    let locationManager = CLLocationManager()
    var initialMapRegion: Bool = false
    let alamoFire = AlamofireService()
    var userLocation: CLLocation?
    var annotations = Array<ARAnnotation>()
    var arViewController: ARViewController!

    
    //IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    //IBAction - pressed monocle
    @IBAction func showARController(_ sender: UIButton) {
        addPinstoMap(completionHandler: {self.showAR()})
    }
    
    //Retrieve photos and add pins to map
    func addPinstoMap(completionHandler: @escaping () -> ()) {
        if let userLoc = userLocation {
            alamoFire.getPhotos(userLocation: userLoc, completionHandler: {
                PhotoAnnotations in
                self.annotations = PhotoAnnotations
                for annotation in self.annotations {
                    let mapAnnotation = MKPointAnnotation()
                    mapAnnotation.coordinate = annotation.location.coordinate
                    mapAnnotation.title = annotation.identifier
                    DispatchQueue.main.async {
                        self.mapView.addAnnotation(mapAnnotation)
                    }
                }
                
                completionHandler()
                
            })
        }
    }
    
    // show AR view
    func showAR(){
        arViewController = ARViewController()
        arViewController.dataSource = self
        arViewController.setAnnotations(annotations)
        //arViewController.presenter.maxVisibleAnnotations = 30
        self.present(arViewController, animated: true, completion: nil)
    }
    
    
    //IBAction - return to camera
    @IBAction func showCameraViewController(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
    }
    
    // MARK: Lock app orientation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FullPhotoSegue" {
            let controller = segue.destination as! DisplayFullPhotoViewController
            controller.imageToDisplay = sender as? UIImage
            controller.delegate = self
        }
    }
}

extension MonocleViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            let location = locations.last!
            userLocation = location
            
            //Set initial mapView region
            if location.horizontalAccuracy < 100, !initialMapRegion {
                initialMapRegion = true
                let span = MKCoordinateSpanMake(0.014, 0.014)
                let region = MKCoordinateRegionMake(location.coordinate, span)
                mapView.region = region
                addPinstoMap(completionHandler: {})
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("hit the fail method")
    }
}

extension MonocleViewController: ARDataSource {
    func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
        let annotationView = AnnotationView()
        annotationView.annotation = viewForAnnotation
        annotationView.delegate = self
        annotationView.frame = CGRect(x: 0, y: 0, width: 135, height: 240)
        
        return annotationView
    }
}

extension MonocleViewController: AnnotationViewDelegate {
    func didTouch(annotationView: AnnotationView) {
        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "FullPhotoSegue", sender: annotationView.image?.image)
    }
}

extension MonocleViewController: FullPhotoDisplayDelegate {
    func dismissView() {
        dismiss(animated: true, completion: nil)
        showAR()
    }
}



