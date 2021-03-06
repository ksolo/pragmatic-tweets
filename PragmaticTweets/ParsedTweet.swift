//
//  ParsedTweet.swift
//  PragmaticTweets
//
//  Created by Kevin Solorio on 12/19/14.
//  Copyright (c) 2014 Kevin Solorio. All rights reserved.
//

import UIKit

class ParsedTweet: NSObject {
 
    var tweetText : String?
    var userName : String?
    var createdAt : String?
    var tweetIdString : String?
    var userAvatarURL : NSURL?
    
    init(tweetText: String?, userName: String?, createdAt: String?, userAvatarURL: NSURL?){
        super.init()
        
        self.tweetText = tweetText
        self.userName = userName
        self.createdAt = createdAt
        self.userAvatarURL = userAvatarURL
    }
    
    override init() {
        super.init()
    }
    
}
