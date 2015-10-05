//
//  CameraRollViewController.swift
//  ios-tumblr-poster
//
//  Created by Mary Xia on 10/4/15.
//  Copyright (c) 2015 Mary Xia. All rights reserved.
//

import UIKit
import Photos // framework

class CameraRollViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var photos: [UIImage]!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        photos = []
        
//        var assetCollection = PHAssetCollection.fetchAssetCollectionsWithType(PHAssetCollectionType.Album, subtype: PHAssetCollectionSubtype.AlbumMyPhotoStream, options: nil)

        var assets = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: nil)
        var manager = PHImageManager.defaultManager()
        
        var i = 0
        for i in 0..<assets.count {
            var asset = assets.objectAtIndex(i) as! PHAsset
            var imageSize = CGSize(width: 100, height: 100)
            var options = PHImageRequestOptions()
            options.resizeMode = PHImageRequestOptionsResizeMode.Exact
            options.deliveryMode = PHImageRequestOptionsDeliveryMode.Opportunistic
            
            manager.requestImageForAsset(asset,
                targetSize: imageSize,
                contentMode: PHImageContentMode.AspectFill,
                options: options)
                {(image, info) -> Void in
                    self.photos.append(image)
//                    self.photoView.image = image
                }
        }
        println(photos.count)

        var photoLibrary = PHPhotoLibrary.sharedPhotoLibrary()
//        var photoAssets = PHAsset.fetchAssetsInAssetCollection(PHAssetCollection, options: nil)
        println("hey")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickedLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
        let photo = photos![indexPath.row] // get photo
        
        cell.photoView.image = photo
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
