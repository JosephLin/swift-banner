//
//  ViewController.swift
//  SwiftyBanner
//
//  Created by Joseph Lin on 8/8/16.
//  Copyright © 2016 Joseph Lin All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func bannerOnly(sender: AnyObject) {
        let banner = WIBannerController()
        banner.configure(
            icon: { (imageView) in
                imageView.image = UIImage(named: "ic_warning")
                imageView.tintColor = UIColor.redColor()
            },
            title: { (label) in
                label.text = "title"
                label.textColor = UIColor.redColor()
            },
            description: nil,
            button: nil
        )
        
        self.presentBanner(banner, animated: true, completion: nil)
    }
    
    @IBAction func bannerWithButton(sender: AnyObject) {
        let banner = WIBannerController()
        banner.configure(
            icon: { (imageView) in
                imageView.image = UIImage(named: "ic_warning")
                imageView.tintColor = UIColor.redColor()
            },
            title: { (label) in
                label.text = "title"
                label.textColor = UIColor.redColor()
            },
            description: nil,
            button: (
                button: { (button) in
                    button.setImage(nil, forState: .Normal)
                    button.setTitle("Done", forState: .Normal)
                    button.setTitleColor(UIColor.redColor(), forState: .Normal)
                },
                action: { banner in
                    banner.dismissBanner(animated: true, completion: nil)
                }
            )
        )
        
        self.presentBanner(banner, animated: true, completion: nil)
    }
    
    @IBAction func bannerWithDetail(sender: AnyObject) {
        let banner = WIBannerController()
        banner.configure(
            icon: { (imageView) in
                imageView.image = UIImage(named: "ic_warning")
                imageView.tintColor = UIColor.redColor()
            },
            title: { (label) in
                label.text = "title"
                label.textColor = UIColor.redColor()
            },
            description: { (label) in
                label.text = "description"
            },
            button: nil
        )
        
        self.presentBanner(banner, animated: true, completion: nil)
    }
    
    @IBAction func bannerWithDetailAndButton(sender: AnyObject) {
        let banner = WIBannerController()
        banner.configure(
            icon: { (imageView) in
                imageView.image = UIImage(named: "ic_warning")
                imageView.tintColor = UIColor.redColor()
            },
            title: { (label) in
                label.text = "title"
                label.textColor = UIColor.redColor()
            },
            description: { (label) in
                label.text = "description"
            },
            button: (
                button: { (button) in
                    button.setTitle("Done", forState: .Normal)
                },
                action: { banner in
                    banner.configure(
                        icon: { (imageView) in
                            imageView.image = UIImage(named: "ic_warning")
                            imageView.tintColor = UIColor.redColor()
                        },
                        title: { (label) in
                            label.text = "title"
                            label.textColor = UIColor.redColor()
                        },
                        description: nil,
                        button: (
                            button: { (button) in
                                button.setImage(nil, forState: .Normal)
                                button.setTitle("Done", forState: .Normal)
                                button.setTitleColor(UIColor.redColor(), forState: .Normal)
                            },
                            action: { banner in
                                banner.dismissBanner(animated: true, completion: nil)
                            }
                        )
                    )
                }
            )
        )
        
        self.presentBanner(banner, animated: true, completion: nil)
    }
}
