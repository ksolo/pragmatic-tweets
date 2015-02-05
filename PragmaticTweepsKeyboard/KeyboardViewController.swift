//
//  KeyboardViewController.swift
//  PragmaticTweepsKeyboard
//
//  Created by Kevin Solorio on 2/4/15.
//  Copyright (c) 2015 Kevin Solorio. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController, UITableViewDataSource, UITableViewDelegate, TwitterAPIRequestDelegate {

    @IBOutlet weak var nextKeyboardButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var tweepNames : [String] = []

    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Perform custom UI setup here
        let twitterParams : Dictionary = ["count" : "100"]
        let twitterAPIURL = NSURL(string: "https://api.twitter.com/1.1/friends/list.json")
        let request = TwitterAPIRequest()
        
        request.sendTwitterRequest(twitterAPIURL, params: twitterParams, delegate: self)
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(textInput: UITextInput) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput) {
        // The app has just changed the document's contents, the document context has been updated.
    
    }
    
    // Actions
    @IBAction func nextKeybaordButtonTapped(sender: UIBarButtonItem) {
    }
    
    // TwitterAPI Delegate
    func handleTwitterData(data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!, fromRequest: TwitterAPIRequest!) {
        if let dataValue = data {
            var parseError : NSError? = nil
            let jsonObject : AnyObject? = NSJSONSerialization.JSONObjectWithData(dataValue, options: NSJSONReadingOptions(0), error: &parseError)
            
            if parseError != nil {
                return
            }
            
            if let jsonDict = jsonObject as? [ String : AnyObject ] {
                if let usersArray = jsonDict["users"] as? NSArray {
                    self.tweepNames.removeAll(keepCapacity: true)
                    for userObject in usersArray {
                        if let userDict = userObject as? [ String : AnyObject ] {
                            let tweepName = userDict["screen_name"] as NSString
                            self.tweepNames.append(tweepName)
                        }
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(),
                    {
                        self.tableView.reloadData()
                    }
                )
            }
        }
        else {
            println("handleTwitterData received no data")
        }
    }
    
    // TableView DataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweepNames.count
    }
    
    // TableView Delegate

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DefaultCell") as UITableViewCell
        cell.textLabel!.text = "@\(tweepNames[indexPath.row])"
        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if let keyInputProxy = textDocumentProxy as? UIKeyInput {
            let atName = "@\(tweepNames[indexPath.row])"
            keyInputProxy.insertText(atName)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
