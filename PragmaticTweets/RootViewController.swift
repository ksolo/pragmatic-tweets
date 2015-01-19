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

public class RootViewController: UITableViewController, TwitterAPIRequestDelegate, UISplitViewControllerDelegate {
    
    var parsedTweets = [ParsedTweet]()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if self.splitViewController != nil {
            self.splitViewController!.delegate = self
        }
        
        reloadTweets()
        
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.refreshControl = refresher
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func handleTweetButtonTapped(sender: AnyObject) {
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
        let twitterParams = ["count" : "100"]
        let twitterAPIURL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
        let request = TwitterAPIRequest()
        
        request.sendTwitterRequest(twitterAPIURL, params: twitterParams, delegate: self)
    }
    
    func handleTwitterData(data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!, fromRequest: TwitterAPIRequest!) {
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
                    parsedTweet.tweetIdString = tweetDict["id_str"] as? NSString
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
    
    // pragma mark segue
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTweetDetailSegue" {
            if let tweetDetailVC = segue.destinationViewController as? TweetDetailViewController {
                let row = self.tableView!.indexPathForSelectedRow()!.row
                let parsedTweet = parsedTweets[row] as ParsedTweet
                tweetDetailVC.tweetIdString = parsedTweet.tweetIdString
            }
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
    
    public override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let parsedTweet = parsedTweets[indexPath.row]
        if self.splitViewController != nil {
            if (self.splitViewController!.viewControllers.count > 1) {
                if let tweetDetailNav =  self.splitViewController!.viewControllers[1] as? UINavigationController {
                    if let tweetDetailVC = tweetDetailNav.viewControllers[0] as? TweetDetailViewController {
                        tweetDetailVC.tweetIdString = parsedTweet.tweetIdString
                    }
                }
            }
            else {
                if let detailVC = self.storyboard!.instantiateViewControllerWithIdentifier("TweetDetailVC") as? TweetDetailViewController {
                    detailVC.tweetIdString = parsedTweet.tweetIdString
                    self.splitViewController!.showDetailViewController(detailVC, sender: self)
                }
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    // pragma mark SplitViewControllerDelegate methods
    public func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool {
        return true
    }

    
}

