//
//  TwitterAPIRequestDelegate.swift
//  PragmaticTweets
//
//  Created by Kevin Solorio on 1/7/15.
//  Copyright (c) 2015 Kevin Solorio. All rights reserved.
//

import Foundation

protocol TwitterAPIRequestDelegate {
    func handleTwitterData(data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!, fromRequest: TwitterAPIRequest!)
}