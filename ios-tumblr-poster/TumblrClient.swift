//
//  TumblrClient.swift
//  ios-tumblr-poster
//
//  Created by Mary Xia on 10/4/15.
//  Copyright (c) 2015 Mary Xia. All rights reserved.
//

import UIKit

let tumblrConsumerKey = "CPa7vG63ffYI8rHQJKZWHyiSEmSxXIi3XXzItJG3BcH2SmQRzs"
let tumblrConsumerSecret = "vE6NO6wpz2P31bKPbJut3nv3cUw5aCfIRVaYooUQ6GNETRjL9c"
let tumblrBaseURL = NSURL(string: "https://api.tumblr.com")

class TumblrClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())? // we have to store this for some reason
        
    class var sharedInstance: TumblrClient { // this is sorta like a class so you don't have to declare the consumer key/secret more than once
        struct Static {
            static let instance = TumblrClient(baseURL: tumblrBaseURL,
                consumerKey: tumblrConsumerKey,
                consumerSecret: tumblrConsumerSecret)
        }
        return Static.instance
    }

    func postToTumblr(blogName: String, params: [String: AnyObject], completion: (result: String?, error: NSError?) -> ()) {
        POST("/v2/blog/" + blogName + "/post",
            parameters: params,
            success: {(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                println("success")
                //do stuff
            },
            failure: {(operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                //do stuff
                println(error)
                completion(result: nil, error: nil)
            })
    }
//        func homeTimelineWithCompletion(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
//            GET("1.1/statuses/home_timeline.json",
//                parameters: params,
//                success: {(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
//                    var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
//                    completion(tweets: tweets, error: nil)
//                    //                for tweet in tweets {
//                    //                    println("text: \(tweet.text), createdAt: \(tweet.createdAt)")
//                    //                }
//                },
//                failure: {(operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
//                    println("failed to get home timeline")
//                    completion(tweets: nil, error: nil)
//            })
//        }
        
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
            
        // Fetch request token; redirect to auth page
        TumblrClient.sharedInstance.requestSerializer.removeAccessToken()
        TumblrClient.sharedInstance.fetchRequestTokenWithPath("https://www.tumblr.com/oauth/request_token",
            method: "GET",
            callbackURL: NSURL(string: "hammy://oauth"),
            scope: nil,
            success: {(requestToken: BDBOAuth1Credential!) -> Void in
                println("got request token")
                var authURL = NSURL(string: "https://www.tumblr.com/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authURL!)
            }
            ) {(error: NSError!) -> Void in
                println("failed to get request token")
                self.loginCompletion?(user: nil, error: error) // no one logged in
        }
    }
        
    func openURL(url: NSURL) {
        if (url.query == nil) { // user does not authorize app
            println("user failed to authorize app. going back.")
            self.loginCompletion?(user: nil, error: nil) // no one logged in
            return
        }
        fetchAccessTokenWithPath("https://www.tumblr.com/oauth/access_token",
            method: "POST",
            requestToken: BDBOAuth1Credential(queryString: url.query),
            success: {(accessToken: BDBOAuth1Credential!) -> Void in
                println("got access token")
                TumblrClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                TumblrClient.sharedInstance.GET("v2/user/info",
                    parameters: nil,
                    success: {(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                        var respData = response["response"] as! NSDictionary // unwrapping stuff
                        var userData = respData["user"] as! NSDictionary // unwrapping stuff

                        var user = User(user: userData as NSDictionary)
                        User.currentUser = user
                        println(User.currentUser?.name)
                        println(User.currentUser?.blogs?.count)
                        self.loginCompletion?(user: user, error: nil)
                    },
                    failure: {(operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                        println("failed to get user")
                        self.loginCompletion?(user: nil, error: error) // no one logged in
                })
            }) {(error: NSError!) -> Void in
                println("error getting access token")
                self.loginCompletion?(user: nil, error: error) // no one logged in
        }
    }
}
