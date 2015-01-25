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
    var preGestureTransform : CGAffineTransform?
    
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

    @IBAction func handlePanGesture(sender: UIPanGestureRecognizer) {
        if sender.state == .Began {
            preGestureTransform = userImageView.transform
        }
        
        if sender.state == .Began || sender.state == .Changed {
            let translation = sender.translationInView(self.userImageView)
            let translatedTransform = CGAffineTransformTranslate(preGestureTransform!, translation.x, translation.y)
            userImageView.transform = translatedTransform
        }
    }
    
    @IBAction func handleDoubleTapGesture(sender: UITapGestureRecognizer) {
        userImageView.transform = CGAffineTransformIdentity
    }
    
    @IBAction func handlePinchGesture(sender: UIPinchGestureRecognizer) {
        if sender.state == .Began {
            preGestureTransform = userImageView.transform
        }
        
        if sender.state == .Began || sender.state == .Changed {
            let scaledTransform = CGAffineTransformScale(preGestureTransform!, sender.scale, sender.scale)
            userImageView.transform = scaledTransform
        }
    }
}
