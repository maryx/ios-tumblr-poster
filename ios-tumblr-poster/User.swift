//
//  User.swift
//  ios-tumblr-poster
//
//  Created by Mary Xia on 10/4/15.
//  Copyright (c) 2015 Mary Xia. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var blogs: NSArray
    var dictionary: NSDictionary

    var defaults = NSUserDefaults.standardUserDefaults()
    
    init(user: NSDictionary) { // the data passed in has 2 outer wrappers that we don't need.
        self.dictionary = user as NSDictionary
        name = dictionary["name"] as? String
        blogs = dictionary["blogs"] as! NSArray
        var blogNames = [String]()
        var i = 0
        for i in 0..<blogs.count {
            blogNames.append(blogs[i]["name"] as! String)
        }
        defaults.setObject(blogNames, forKey: "blogNames")
        println(defaults.objectForKey("blogNames"))
    }
    
    func logout() {
        User.currentUser = nil
        TumblrClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User? {
        get {
        if (_currentUser == nil) {
        var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
        if (data != nil) {
        var dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as! NSDictionary
        _currentUser = User(user: dictionary)
        }
        }
        return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                var data = NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: nil, error: nil)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}