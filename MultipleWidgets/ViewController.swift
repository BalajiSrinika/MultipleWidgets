//
//  ViewController.swift
//  MultipleWidgets
//
//  Created by Balaji Pandian on 27/07/20.
//

import UIKit
import Photos

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PHPhotoLibrary.requestAuthorization({status in
             switch status {
             case .authorized:
                print("authorized!!")
             case .denied:
                 print("denied")
             // probably alert the user that they need to grant photo access
             case .notDetermined:
                 print("not determined")
             case .restricted:
                 print("restricted")
                 // probably alert the user that photo access is restricted
             case .limited:
                print("not determined")
             @unknown default:
                print("not determined")
             }
         })
        
        let getPhotos = GetTotalGallery().allPhotos
        print(getPhotos.count)
      
    }


}

