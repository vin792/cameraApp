/*
	Copyright (C) 2016 Apple Inc. All Rights Reserved.
	See LICENSE.txt for this sample’s licensing information
	
	Abstract:
	Photo capture delegate.
*/

import AVFoundation
import Photos
import CoreLocation

class PhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
	private(set) var requestedPhotoSettings: AVCapturePhotoSettings
	
	private let willCapturePhotoAnimation: () -> ()
	
	private let completed: (PhotoCaptureDelegate) -> ()
	
	private var photoData: Data? = nil
    
    private var userLoc: CLLocation?

    init(with requestedPhotoSettings: AVCapturePhotoSettings, userLocation: CLLocation, willCapturePhotoAnimation: @escaping () -> (), completed: @escaping (PhotoCaptureDelegate) -> ()) {
		self.requestedPhotoSettings = requestedPhotoSettings
		self.willCapturePhotoAnimation = willCapturePhotoAnimation
		self.completed = completed
        self.userLoc = userLocation
	}
	
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
		if let photoSampleBuffer = photoSampleBuffer {
            photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
		}
		else {
			print("Error capturing photo: \(String(describing: error?.localizedDescription))")
			return
		}
	}
			
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishCaptureForResolvedSettings resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
		if let error = error {
			print("Error capturing photo: \(error)")
			return
		}
		
		guard let photoData = photoData else {
			print("No photo data resource")
			return
		}
        print(photoData)
        
        let imageDataToSave = ["binaryPhoto" : "jakldjfa",
                               "latitude" : 231232,
                               "longitude" : 238237489,
                               "altitude" : 0098908,
                               "username" : "generic user"
        ] as [String : Any]
        
        
        //userLocation when taking photo
        if let userLocation = userLoc {
            print(userLocation)
        }
 
        let alamoService = AlamofireService()
        alamoService.sendImageDataToServer(imageDataToSave: imageDataToSave)
	}

}
