//
//  FetchingData.swift
//  MultipleWidgets
//
//  Created by Balaji Pandian on 27/07/20.
//

import Foundation
import Photos


struct GetPhotoAsset  {
    
    var allPhotos = NSMutableArray()
 
    static func getAllPhotos() -> GetPhotoAsset {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let photosFromCameraRoll : PHFetchResult = PHAsset.fetchAssets(with: .image, options: options)
        
        var loadedPhotos = NSMutableArray()
        photosFromCameraRoll.enumerateObjects { (asset, index, stop) -> Void in
            loadedPhotos.add(asset)
        }
        
        if let assetsArray = loadedPhotos as? [PHAsset]{
            let exceptScreenshot = assetsArray
                .filter {$0.mediaSubtypes != PHAssetMediaSubtype.photoScreenshot}
                .filter {$0.mediaSubtypes != PHAssetMediaSubtype.photoPanorama}
                .filter{
                    if #available(iOS 9.1, *) {
                        return $0.mediaSubtypes != PHAssetMediaSubtype.photoLive
                    } else {
                        return false
                    }
                    
                }
            
            let filteredArray = NSMutableArray()
            filteredArray.addObjects(from: exceptScreenshot)
            loadedPhotos = filteredArray
        }
        
        return GetPhotoAsset(allPhotos: loadedPhotos)
    }
  
}


