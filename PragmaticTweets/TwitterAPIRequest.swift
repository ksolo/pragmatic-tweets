//
//  TwitterAPIRequest.swift
//  PragmaticTweets
//
//  Created by Kevin Solorio on 1/7/15.
//  Copyright (c) 2015 Kevin Solorio. All rights reserved.
//

import UIKit
import Social
import Accounts

class TwitterAPIRequest: NSObject {
   
    func sendTwitterRequest(requestURL: NSURL!, params: Dictionary<String, String>, delegate: TwitterAPIRequestDelegate?) {
        let accountStore = ACAccountStore()
        let twitterAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        accountStore.requestAccessToAccountsWithType(twitterAccountType, options: nil, completion:
            { (Bool granted, NSError error) -> Void in
                if (!granted) {
                    println("account access not granted")
                }
                else {
                    let twitterAccounts = accountStore.accountsWithAccountType(twitterAccountType)
                    if twitterAccounts.count == 0 {
                        println("no twitter accounts configure")
                        return
                    }
                    else {
                        let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestURL, parameters: params)
                        request.account = twitterAccounts[0] as ACAccount
                        request.performRequestWithHandler(
                            { (data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) -> Void in
                                delegate!.handleTwitterData(data, urlResponse: urlResponse, error: error, fromRequest: self)
                            }
                        )
                    }
                }
            }
        )
    }
    
}
