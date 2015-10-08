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

    var defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        // grab previously saved values
        println(blogName.text)
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
        defaults.setObject(blogName.text, forKey: "updatedBlogName")
        defaults.synchronize()
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
        defaults.setObject(blogName.text, forKey: "blogName")
        defaults.setObject(text.text, forKey: "text")
        defaults.setObject(tags.text, forKey: "tags")
        defaults.synchronize()
        dismissViewControllerAnimated(true, completion: nil)
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
