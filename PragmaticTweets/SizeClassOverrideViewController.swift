//
//  SizeClassOverrideViewController.swift
//  PragmaticTweets
//
//  Created by Kevin Solorio on 1/18/15.
//  Copyright (c) 2015 Kevin Solorio. All rights reserved.
//

import UIKit

class SizeClassOverrideViewController: UIViewController {
    
    var embeddedSplitVC : UISplitViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if size.width > 480.0 {
            let overrideTraits = UITraitCollection(horizontalSizeClass: UIUserInterfaceSizeClass.Regular)
            self.setOverrideTraitCollection(overrideTraits, forChildViewController: embeddedSplitVC!)
        }
        else {
            self.setOverrideTraitCollection(nil, forChildViewController: embeddedSplitVC!)
        }
    }
    
    // pragma mark Segue overrides
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "embedSplitViewSegue" {
            self.embeddedSplitVC = segue.destinationViewController as? UISplitViewController
        }
    }

}
