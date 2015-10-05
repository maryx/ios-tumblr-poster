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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        println(photoView)
    }

}
