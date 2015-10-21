//
//  SettingsViewController.swift
//  ios-tumblr-poster
//
//  Created by Mary Xia on 10/4/15.
//  Copyright (c) 2015 Mary Xia. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var blogName: UITextField!
    @IBOutlet weak var text: UITextField!
    @IBOutlet weak var tags: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var clearDataButton: UIButton!

    var defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        errorMessage.hidden = true
        // grab previously saved values
        blogName.text = defaults.stringForKey("blogName")
        text.text = defaults.stringForKey("text")
        tags.text = defaults.stringForKey("tags")

//        // we only want to set the updated fields until we press save
//        defaults.setObject(blogName.text, forKey: "updatedBlogName")
//        defaults.setObject(text.text, forKey: "updatedText")
//        defaults.setObject(tags.text, forKey: "updatedTags")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func updatedBlogName(sender: AnyObject) {
        validateBlogName()
    }
    
    func validateBlogName() -> Bool {
        if let ownsBlog = find(defaults.objectForKey("blogNames") as! [String], blogName.text.lowercaseString) {
            defaults.setObject(blogName.text, forKey: "updatedBlogName")
            defaults.synchronize()
            saveButton.enabled = true
            blogName.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            errorMessage.hidden = true
            return true
        } else {
            saveButton.enabled = false
            blogName.textColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1)
            errorMessage.hidden = false
            return false
        }
    }
    
    @IBAction func updatedText(sender: AnyObject) {
        defaults.setObject(text.text, forKey: "updatedText")
        defaults.synchronize()
    }
    
    @IBAction func updatedTags(sender: AnyObject) {
        defaults.setObject(tags.text, forKey: "updatedTags")
        defaults.synchronize()
    }
    
    @IBAction func clickedCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func clickedSaveButton(sender: AnyObject) {
        if (validateBlogName()) {
            defaults.setObject(blogName.text, forKey: "blogName")
            defaults.setObject(text.text, forKey: "text")
            defaults.setObject(tags.text, forKey: "tags")
            defaults.synchronize()
            dismissViewControllerAnimated(true, completion: nil)
        }
    }

    
    @IBAction func clickedClearDataButton(sender: AnyObject) {
        defaults.setObject([], forKey: "postedPhotos")
        defaults.synchronize()
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
