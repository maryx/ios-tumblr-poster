//
//  LoginViewController.swift
//  ios-tumblr-poster
//
//  Created by Mary Xia on 10/4/15.
//  Copyright (c) 2015 Mary Xia. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickedLoginButton(sender: AnyObject) {
        TumblrClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) in
            print(user)
            if (user != nil) {
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                print("not logged in")
            }
        }
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
