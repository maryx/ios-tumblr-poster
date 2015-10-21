//
//  CameraRollViewController.swift
//  ios-tumblr-poster
//
//  Created by Mary Xia on 10/4/15.
//  Copyright (c) 2015 Mary Xia. All rights reserved.
//

import UIKit
import Photos // framework

class CameraRollViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, PhotoCellDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var photos: [UIImage]!
    var photoURLs: [String]!

    var photoStates = [Int:Bool]() // stuff for cell reuse UI issues
    var defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        photos = []
        photoURLs = []
        
        var assets = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: nil)
        var manager = PHImageManager.defaultManager()
        
        var i = 0
        for i in 0..<assets.count {
            var asset = assets.objectAtIndex(i) as! PHAsset
            var imageSize = PHImageManagerMaximumSize //CGSize(width: 800.0, height: 800.0)
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

                    let description = info.description.lowercaseString
                    let regex = "file:([^ ,])*" // Gets PHImageFileURLKey
                    if let match = description.rangeOfString(regex, options: .RegularExpressionSearch){
                        self.photoURLs.append(description.substringWithRange(match))
                    }

                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickedLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (photos != nil) {
            return photos.count
        } else {
            return 0
        }
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
        let photo = photos![indexPath.row] // get photo
        let photoURL = photoURLs![indexPath.row] // get photo url
        
        cell.photoView.image = photo
        cell.photoURL = photoURL

        // stuff for cell reuse UI issues
        cell.delegate = self
        if let posted = find(defaults.objectForKey("postedPhotos") as! [String], cell.photoURL) {
            cell.photoBlur.hidden = photoStates[indexPath.row] ?? false
        } else {
            cell.photoBlur.hidden = photoStates[indexPath.row] ?? true
        }
        return cell
    }

    // optional override // not sure what this func is doing here. Maybe can delete later.
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // post image to tumblr
    }

    // stuff for cell reuse UI issues
    func photoCell(photoCell: PhotoCell, didChangeValue value: Bool) {
        let indexPath = collectionView.indexPathForCell(photoCell)!
        //do something here
        photoStates[indexPath.row] = value
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
