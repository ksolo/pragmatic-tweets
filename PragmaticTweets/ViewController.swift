//
//  ViewController.swift
//  PragmaticTweets
//
//  Created by Kevin Solorio on 11/11/14.
//  Copyright (c) 2014 Kevin Solorio. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController {

    @IBOutlet weak var twitterWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func handleTweetButtonTapped(sender: UIButton) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let tweetVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweetVC.setInitialText(
                "I just finished the initial project in iOS 8 SDK Development. #pragsios8"
            )
            self.presentViewController(tweetVC, animated: true, completion: nil)
        }
        else {
            println("Can't send tweet")
        }
    }
    
    @IBAction func handleShowMyTweetsTapped(sender: UIButton) {
        let url = NSURL(string: "http://www.twitter.com/kmsolorio")
        let urlRequest = NSURLRequest(URL: url!)
        self.twitterWebView.loadRequest(urlRequest)
    }
    
}

