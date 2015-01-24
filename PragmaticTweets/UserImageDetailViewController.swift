//
//  UserImageDetailViewController.swift
//  PragmaticTweets
//
//  Created by Kevin Solorio on 1/24/15.
//  Copyright (c) 2015 Kevin Solorio. All rights reserved.
//

import UIKit

class UserImageDetailViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    
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
        super.viewWillAppear(animated)
        if userImageURL != nil {
            if let imageData = NSData(contentsOfURL: userImageURL!) {
                userImageView.image = UIImage(data: imageData)
            }
        }
    }

}
