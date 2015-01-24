//
//  UserDetailViewController.swift
//  PragmaticTweets
//
//  Created by Kevin Solorio on 1/13/15.
//  Copyright (c) 2015 Kevin Solorio. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController, TwitterAPIRequestDelegate {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userRealNameLabel: UILabel!
    @IBOutlet weak var userScreenNameLabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var userDescriptionLabel: UILabel!
    
    var screenName : String?
    var userImageURL : NSURL?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        if screenName == nil {
            return
        }
        
        let twitterRequest = TwitterAPIRequest()
        let twitterParams = ["screen_name" : screenName!]
        let twitterAPIURL = NSURL(string: "https://api.twitter.com/1.1/users/show.json")
        
        twitterRequest.sendTwitterRequest(twitterAPIURL, params: twitterParams, delegate: self)
    }
    
    // pragma mark TwitterAPIRequestDelegate methods
    func handleTwitterData(data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!, fromRequest: TwitterAPIRequest!) {
        if let dataValue = data {
            let jsonString = NSString(data: data, encoding:NSUTF8StringEncoding)
            var parseError : NSError? = nil
            let jsonObject : AnyObject? = NSJSONSerialization.JSONObjectWithData(dataValue, options: NSJSONReadingOptions(0), error: &parseError)
            
            if let errorValue = parseError {
                return
            }
            
            if let tweetDict = jsonObject as? Dictionary<String, AnyObject> {
                dispatch_async(dispatch_get_main_queue(),
                    { () -> Void in
                        self.userRealNameLabel.text = tweetDict["name"] as? NSString
                        self.userScreenNameLabel.text = tweetDict["screen_name"] as? NSString
                        self.userLocationLabel.text = tweetDict["location"] as? NSString
                        self.userDescriptionLabel.text = tweetDict["description"] as? NSString
                        self.userImageURL = NSURL(string: tweetDict["profile_image_url"] as NSString!)
                        
                        if self.userImageURL != nil {
                            if let userImageData = NSData(contentsOfURL: self.userImageURL!) {
                                self.userImageView.image = UIImage(data:userImageData)
                            }
                        }
                    }
                )
            }
        }
    }
    
    // Segue Methods
    @IBAction func unwindToUserDetailVC(segue: UIStoryboardSegue) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showUserImageDetailSegue" {
            if let imageDetailVC = segue.destinationViewController as? UserImageDetailViewController {
                var urlString = userImageURL!.absoluteString?.stringByReplacingOccurrencesOfString("_normal", withString: "", options: nil, range: nil)
                imageDetailVC.userImageURL = NSURL(string: urlString!)
            }
        }
    }

}
