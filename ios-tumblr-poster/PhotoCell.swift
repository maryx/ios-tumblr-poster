//
//  PhotoCell.swift
//  ios-tumblr-poster
//
//  Created by Mary Xia on 10/5/15.
//  Copyright (c) 2015 Mary Xia. All rights reserved.
//

import UIKit


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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Layering stuff -- probably not the right way to do it
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
        if let index = find(postedPhotos, photoURL) {
            println("already posted/queued this one")
        } else {
            loadingIndicator.hidden = false // this gets a bit buggy with cell reuse UI but it's not important enough to fix
            loadingIndicator.startAnimating()
            var blogName = (defaults.stringForKey("blogName") as String!) + ".tumblr.com"
            var params = [String: AnyObject]()
            params["type"] = "photo"
            params["data64"] = UIImagePNGRepresentation(photoView.image).base64EncodedStringWithOptions(nil)
            params["state"] = postState
            params["tags"] = defaults.stringForKey("tags") as String!
            params["caption"] = defaults.stringForKey("text") as String!
            TumblrClient.sharedInstance.postToTumblr(blogName, params: params, completion: {(result, error) -> () in
                self.photoBlur.hidden = false
                self.loadingIndicator.hidden = true
                self.loadingIndicator.stopAnimating()
                postedPhotos.append(self.photoURL)
                self.defaults.setObject(postedPhotos, forKey: "postedPhotos")
                self.defaults.synchronize()
                println("done posting/queuing")
            })
        }
    }

    @IBAction func clickedEditButton(sender: AnyObject) {
        // gonna just rotate for now
        //var rotatedImage = UIImage(CGImage: photoView.image!.CGImage, scale: 1.0, orientation: .DownMirrored)
        //photoView.image = rotatedImage
        UIView.animateWithDuration(0.5, animations: {
            self.photoView.transform = CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) / 180.0)
        })
    }
    
    func blurredImage() {
        delegate?.photoCell?(self, didChangeValue: false)
    }
}
