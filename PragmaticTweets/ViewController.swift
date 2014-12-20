//
//  ViewController.swift
//  PragmaticTweets
//
//  Created by Kevin Solorio on 11/11/14.
//  Copyright (c) 2014 Kevin Solorio. All rights reserved.
//

import UIKit
import Social

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
    
    func reloadTweets() {
        
    }
    
    // pragma mark Datasource Compliance
    
    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedTweets.count
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        let parsedTweet = parsedTweets[indexPath.row]
        
        cell.textLabel?.text = parsedTweet.tweetText
        return cell
    }

    
}

