//
//  FetchGetGallery.swift
//  MultipleWidgets
//
//  Created by Balaji Pandian on 29/07/20.
//

import Foundation
import Photos

struct GetTotalGallery  {
    
    var allPhotos = NSMutableArray()
    var allVideos = NSMutableArray()
    var allScreenshots = NSMutableArray()
  
    static func getAll() -> GetTotalGallery {
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
        
        //video
        let photosFromCameraRollVideo : PHFetchResult = PHAsset.fetchAssets(with: .video, options: options)
        let getVideos = NSMutableArray()
        photosFromCameraRollVideo.enumerateObjects { (asset, index, stop) -> Void in
            
            getVideos.add(asset)
            print(asset)
        }
        
        //screenshot
        
        let totScreenshot = NSMutableArray()
        let smartAlbums  = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.smartAlbumScreenshots, options: nil)
        var smartAlbumsResult : PHFetchResult<PHAsset>!
        
        smartAlbums.enumerateObjects({
            collection , index, stop in
            smartAlbumsResult = PHAsset.fetchAssets(in: collection, options: options)
        })
        smartAlbumsResult.enumerateObjects{ (asset, count, boolValue) in
            totScreenshot.add(asset)
            
        }
        
        return GetTotalGallery(allPhotos: loadedPhotos, allVideos: getVideos, allScreenshots: totScreenshot)
    }
  
}

struct details {
    var displayName : String?
    var asset : NSMutableArray?
}

struct GetGallery  {
    
    var Details : details
  
    static func getAllPhotos() -> GetGallery {
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
        
    
        return  GetGallery(Details:details(displayName: "Photos", asset: loadedPhotos))
    }
    
    static  func getAllVideos()-> GetGallery {
        
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
       
        let photosFromCameraRollVideo : PHFetchResult = PHAsset.fetchAssets(with: .video, options: options)
        let getVideos = NSMutableArray()
        photosFromCameraRollVideo.enumerateObjects { (asset, index, stop) -> Void in
            
            //self.allVideo.add(asset)
            
            getVideos.add(asset)
            print(asset)
        }
        return GetGallery(Details:details(displayName: "Videos", asset: getVideos))
    }
    
    static func getAllScreenShot()-> GetGallery {
        
        let totScreenshot = NSMutableArray()
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let smartAlbums  = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.smartAlbumScreenshots, options: nil)
        var smartAlbumsResult : PHFetchResult<PHAsset>!
        
        smartAlbums.enumerateObjects({
            collection , index, stop in
            smartAlbumsResult = PHAsset.fetchAssets(in: collection, options: options)
        })
        smartAlbumsResult.enumerateObjects{ (asset, count, boolValue) in
            totScreenshot.add(asset)
            
        }
        
        return GetGallery(Details:details(displayName: "Screenshot", asset: totScreenshot))
    }
}
