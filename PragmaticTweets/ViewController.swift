//
//  ViewController.swift
//  PragmaticTweets
//
//  Created by Kevin Solorio on 11/11/14.
//  Copyright (c) 2014 Kevin Solorio. All rights reserved.
//

import UIKit
import Social
import Accounts

let defaultAvatarURL = NSURL(string: "https://abs.twimg.com/sticky/default_profile_images/default_profile_6_200x200.png")

public class ViewController: UITableViewController {
    
    var parsedTweets = [
        ParsedTweet(tweetText: "iOS 8 SDK now in print!", userName: "@pragprog", createdAt: "2014-08-20 16:44:30 EDT", userAvatarURL: defaultAvatarURL),
        ParsedTweet(tweetText: "Whoooo!", userName: "@kmsolorio", createdAt: "2014-08-21 15:33:15 EDT", userAvatarURL: defaultAvatarURL),
        ParsedTweet(tweetText: "Work please", userName: "@lyly5545", createdAt: "2014-08-22 12:11:10 EDT", userAvatarURL: defaultAvatarURL)
    ]
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        reloadTweets()
        
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.refreshControl = refresher
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func handleTweetButtonTapped(sender: UIButton) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let tweetVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            let message = NSLocalizedString("I just finished the first project in iOS SDK 8 Development. #pragsios8", comment: "")
            
            tweetVC.setInitialText(message)
            self.presentViewController(tweetVC, animated: true, completion: nil)
        }
        else {
            println("Can't send tweet")
        }
    }
    
    @IBAction func handleRefresh(sender: AnyObject?) {
        self.parsedTweets.append(
            ParsedTweet(
                tweetText: "New Row",
                userName: "@refresh",
                createdAt: NSDate().description,
                userAvatarURL: defaultAvatarURL))
        self.reloadTweets()
        self.refreshControl!.endRefreshing()
    }
    
    func reloadTweets() {
        let accountStore = ACAccountStore()
        let twitterAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        accountStore.requestAccessToAccountsWithType(twitterAccountType,
            options: nil,
            completion: {
                (granted: Bool, error: NSError!) -> Void in
                if (!granted) {
                    println("no access")
                }
                else {
                    let twitterAccounts = accountStore.accountsWithAccountType(twitterAccountType)
                    if (twitterAccounts.count == 0) {
                        println("no twitter accounts configured")
                        return
                    }
                    else {
                        let twitterParams = ["count" : 300]
                        let twitterAPIURL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
                        let request = SLRequest(forServiceType: SLServiceTypeTwitter,
                            requestMethod: SLRequestMethod.GET,
                            URL: twitterAPIURL,
                            parameters: twitterParams)
                        
                        request.account = twitterAccounts[0] as ACAccount
                        request.performRequestWithHandler(
                            {
                                (NSData data, NSURLResponse urlResponse, NSError error) -> Void in
                                self.handleTwitterData(data, urlResponse: urlResponse, error: error)
                            }
                        )
                    }
                }
            }
        )
    }
    
    func handleTwitterData(data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) {
        if let dataValue = data {
            var parseError : NSError? = nil
            let jsonObject = NSJSONSerialization.JSONObjectWithData(dataValue,
                options: NSJSONReadingOptions(0),
                error: &parseError)
            
            println("JSON error: \(parseError)\nJSON response: \(jsonObject)")
        }
        else {
            println("handleTWitterData did not receive any data")
        }
    }
    
    // pragma mark Datasource Compliance
    
    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedTweets.count
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomTweetCell") as ParsedTweetCell
        let parsedTweet = parsedTweets[indexPath.row]
        
        cell.userNameLabel.text = parsedTweet.userName
        cell.tweetTextLabel.text = parsedTweet.tweetText
        cell.createdAtLabel.text = parsedTweet.createdAt
        
        if let avatarURL = parsedTweet.userAvatarURL {
            cell.avatarImageView.image = UIImage(data: NSData(contentsOfURL: avatarURL)!)
        }
        
        return cell
    }

    
}

