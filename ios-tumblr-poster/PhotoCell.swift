//
//  PhotoCell.swift
//  ios-tumblr-poster
//
//  Created by Mary Xia on 10/5/15.
//  Copyright (c) 2015 Mary Xia. All rights reserved.
//

import UIKit
import Photos // framework

@objc protocol PhotoCellDelegate { // Needed to prevent cell reuse from messing up styles
    optional func photoCell(photoCell: PhotoCell, didChangeValue value: Bool)
}

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var photoBlur: UIVisualEffectView!
    @IBOutlet weak var PostButton: UIButton!
    @IBOutlet weak var QueueButton: UIButton!
    @IBOutlet weak var EditButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    weak var delegate: PhotoCellDelegate? // This prevents cell reuse from causing the styles to be off

    var defaults = NSUserDefaults.standardUserDefaults()
    var photoURL = ""
    var rotatedImage: UIImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        rotatedImage = photoView.image
        
        // Layering stuff just in case. probably don't need it in prod.
        photoView.layer.zPosition = 1
        photoBlur.layer.zPosition = 2
        loadingIndicator.layer.zPosition = 3
        PostButton.layer.zPosition = 4
        QueueButton.layer.zPosition = 4
        EditButton.layer.zPosition = 4
        
        loadingIndicator.hidden = true
        photoBlur.alpha = 0.5
        photoBlur.hidden = true
        // Does UI stuff for cell reuse problem
        PostButton.addTarget(self, action: "blurredImage", forControlEvents: UIControlEvents.AllTouchEvents)
        QueueButton.addTarget(self, action: "blurredImage", forControlEvents: UIControlEvents.AllTouchEvents)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    @IBAction func clickedPostButton(sender: AnyObject) {
        sendPhoto("published")
    }
    
    @IBAction func clickedQueueButton(sender: AnyObject) {
        sendPhoto("queue")
    }

    private func sendPhoto(postState: String) {
        var postedPhotos = defaults.objectForKey("postedPhotos") as! [String]
        // If you haven't posted the image before OR if you don't care about reposting, post it again.
        if ((postedPhotos.indexOf(photoURL) == nil) || (defaults.boolForKey("repostImage") ?? false)) {
            photoBlur.hidden = false // photoBlur has loadingIndicator as a subview so you need to show this one first :/
            loadingIndicator.hidden = false // this gets a bit buggy with cell reuse UI but it's not important enough to fix
            loadingIndicator.startAnimating()
            var blogName = (defaults.stringForKey("blogName") as String!) + ".tumblr.com"
            var params = [String: AnyObject]()
            
            params["type"] = "photo"
            params["data64"] = UIImagePNGRepresentation(self.photoView.image!)!.base64EncodedStringWithOptions([])
            params["state"] = postState
            params["tags"] = defaults.stringForKey("tags") as String!
            params["caption"] = defaults.stringForKey("text") as String!
            TumblrClient.sharedInstance.postToTumblr(blogName, params: params, completion: {(result, error) -> () in
                self.loadingIndicator.hidden = true
                self.loadingIndicator.stopAnimating()
                postedPhotos.append(self.photoURL)
                self.defaults.setObject(postedPhotos, forKey: "postedPhotos")
                self.defaults.synchronize()
                if (postState == "published") {
                    self.PostButton.setTitle("Posted", forState: UIControlState.Normal)
                } else {
                    self.QueueButton.setTitle("Queued", forState: UIControlState.Normal)
                }
                print("done posting/queuing")
            })
        } else {
            print("can't repost an image you already posted")
        }
    }

    @IBAction func clickedEditButton(sender: AnyObject) {
        // Nothing really animates right now
//        UIView.animateWithDuration(0.5, animations: {
            self.rotatedImage = UIImage(CGImage: self.photoView.image!.CGImage!, scale: 1.0, orientation: .Right)
            self.photoView.image = self.rotatedImage

            UIGraphicsBeginImageContext(self.photoView.frame.size)
            self.photoView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
            var newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.photoView.image = newImage

//             This is the only way to grab a rotated image. sigh.
//        UIImageWriteToSavedPhotosAlbum(rotatedImage,
//            self, {
//            // Get the most recent image (the one above) and set the current image to that image
//            var assets = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: nil)
//            var manager = PHImageManager.defaultManager()
//            var mostRecentImage = assets.objectAtIndex(assets.count - 1) as! PHAsset
//            var imageSize = PHImageManagerMaximumSize
//            var options = PHImageRequestOptions()
//            options.synchronous = false
//            options.resizeMode = PHImageRequestOptionsResizeMode.Exact
//            options.deliveryMode = PHImageRequestOptionsDeliveryMode.Opportunistic
//            
//            manager.requestImageForAsset(mostRecentImage,
//                targetSize: imageSize,
//                contentMode: PHImageContentMode.AspectFill,
//                options: options)
//                {(image, info) -> Void in
//                    self.photoView.image = image
//            }
//            return nil
//        }(), nil)
//        })
    }
    
    func blurredImage() {
        delegate?.photoCell?(self, didChangeValue: false)
    }
}
