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
    var defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        photos = []
        
        var assets = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: nil)
        var manager = PHImageManager.defaultManager()
        
        var i = 0
        for i in 0..<assets.count {
            var asset = assets.objectAtIndex(i) as! PHAsset
            var imageSize = PHImageManagerMaximumSize//CGSize(width: 800.0, height: 800.0)
            var options = PHImageRequestOptions()
            options.synchronous = true
            options.resizeMode = PHImageRequestOptionsResizeMode.Exact
            options.deliveryMode = PHImageRequestOptionsDeliveryMode.Opportunistic
            
            manager.requestImageForAsset(asset,
                targetSize: imageSize,
                contentMode: PHImageContentMode.AspectFill,
                options: options)
                {(image, info) -> Void in
                    self.photos.append(image)
                }
        }
        println(photos.count)
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

    // optional override
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // post image to tumblr
        
        
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
