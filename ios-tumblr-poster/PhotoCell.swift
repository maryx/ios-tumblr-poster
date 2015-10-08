//
//  PhotoCell.swift
//  ios-tumblr-poster
//
//  Created by Mary Xia on 10/5/15.
//  Copyright (c) 2015 Mary Xia. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var photoBlur: UIVisualEffectView!
    @IBOutlet weak var PostButton: UIButton!
    @IBOutlet weak var EditButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var defaults = NSUserDefaults.standardUserDefaults()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoBlur.alpha = 0
        loadingIndicator.alpha = 0
    }

    @IBAction func clickedPostButton(sender: AnyObject) {
        loadingIndicator.alpha = 1
        loadingIndicator.startAnimating()
        println(defaults.objectForKey("blogNames"))
        var blogName = defaults.stringForKey("blogName") as String!
        var params = [String: AnyObject]()
        params["type"] = "photo"
        params["data64"] = UIImagePNGRepresentation(photoView.image).base64EncodedStringWithOptions(nil)
        params["state"] = "published"
        params["tags"] = defaults.stringForKey("tags") as String!
        params["caption"] = defaults.stringForKey("text") as String!
        
        TumblrClient.sharedInstance.postToTumblr(blogName, params: params, completion: {(result, error) -> () in
            self.photoBlur.alpha = 0.5
            self.loadingIndicator.alpha = 0
            self.loadingIndicator.stopAnimating()
            println("done posting")
        })
    }
    @IBAction func clickedEditButton(sender: AnyObject) {
        println("clicked edit")
    }
    
}
