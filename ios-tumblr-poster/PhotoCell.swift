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
    @IBOutlet weak var PostButton: UIButton!
    @IBOutlet weak var EditButton: UIButton!
    
    var defaults = NSUserDefaults.standardUserDefaults()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func clickedPostButton(sender: AnyObject) {
        println(defaults.objectForKey("blogNames"))
        var blogName = defaults.stringForKey("blogName") as String!
        var params = [String: AnyObject]()
        params["type"] = "photo"
        params["data64"] = UIImagePNGRepresentation(photoView.image).base64EncodedStringWithOptions(nil)
        params["state"] = "published"
        params["tags"] = defaults.stringForKey("tags") as String!
        params["caption"] = defaults.stringForKey("text") as String!
        
        TumblrClient.sharedInstance.postToTumblr(blogName, params: params, completion: {(result, error) -> () in
            println("done posting")
        })
    }
    @IBAction func clickedEditButton(sender: AnyObject) {
        println("clicked edit")
    }
    
}
