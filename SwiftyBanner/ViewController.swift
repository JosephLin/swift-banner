//
//  ViewController.swift
//  SwiftyBanner
//
//  Created by Joseph Lin on 8/8/16.
//  Copyright © 2016 Joseph Lin All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func firstButtonTapped(sender: AnyObject) {
        let banner = WIBannerController(title: "Test", icon: nil, description: "Test Test", buttonTitle: "Done") { banner in
            banner.dismissBanner(animated: true, completion: nil)
        }
        self.presentBanner(banner, animated: true, completion: nil)
    }
    
    @IBAction func secondButtonTapped(sender: AnyObject) {
        let banner = WIBannerController(title: "Test", icon: UIImage(named: "ic_warning"), description: "Test Test", buttonTitle: "Done") { banner in
            banner.dismissBanner(animated: true, completion: nil)
        }
        self.presentBanner(banner, animated: false, completion: nil)
    }
}
