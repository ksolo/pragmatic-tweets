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

public class RootViewController: UITableViewController {
    
    var parsedTweets = [ParsedTweet]()
    
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
            let jsonObject : AnyObject! = NSJSONSerialization.JSONObjectWithData(dataValue,
                options: NSJSONReadingOptions(0),
                error: &parseError)
            
            if let jsonArray = jsonObject as? Array<Dictionary<String, AnyObject>> {
                self.parsedTweets.removeAll(keepCapacity: true)
                
                for tweetDict in jsonArray {
                    let parsedTweet = ParsedTweet()
                    let userDict = tweetDict["user"] as NSDictionary
                    
                    parsedTweet.tweetText = tweetDict["text"] as? NSString
                    parsedTweet.createdAt = tweetDict["created_at"] as? NSString
                    parsedTweet.userName = userDict["name"] as NSString
                    parsedTweet.userAvatarURL = NSURL(string: userDict["profile_image_url"] as NSString!)
                    
                    self.parsedTweets.append(parsedTweet)
                }
                
                dispatch_async(dispatch_get_main_queue(),
                { () -> Void in
                    self.tableView.reloadData()
                })
            }
            
        }
        else {
            return
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
            cell.avatarImageView.image = nil
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
            { () -> Void in
                if let imageData = NSData(contentsOfURL: avatarURL) {
                    let avatarImage = UIImage(data: imageData)
                
                    dispatch_async(dispatch_get_main_queue(),
                    {
                        if cell.userNameLabel.text == parsedTweet.userName {
                            cell.avatarImageView.image = avatarImage
                        }
                        else {
                            println("Oops, wrong cell, never mind")
                        }
                    })
                }
            })
            cell.avatarImageView.image = UIImage(data: NSData(contentsOfURL: avatarURL)!)
        }
        
        return cell
    }

    
}

