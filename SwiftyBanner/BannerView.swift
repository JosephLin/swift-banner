//
//  BannerView.swift
//  SwiftyBanner
//
//  Created by Joseph Lin on 8/10/16.
//  Copyright © 2016 Joseph Lin. All rights reserved.
//

import UIKit

typealias ButtonAction = () -> Void


@IBDesignable class BannerView: UIView {

    enum State {
        case Hidden
        case Banner
    }

    lazy var imageView: UIImageView = {
        return UIImageView()
    }()
    lazy var label: UILabel = {
        return UILabel()
    }()
    lazy var button: UIButton = {
        return UIButton(type: .System)
    }()
    
    @IBInspectable var image: UIImage? {
        didSet {
            self.setNeedsLayout()
        }
    }
    @IBInspectable var text: String? {
        didSet {
            self.setNeedsLayout()
        }
    }
    @IBInspectable var buttonTitle: String? {
        didSet {
            self.setNeedsLayout()
        }
    }
    var buttonAction: ButtonAction?
    
    private weak var leftConstraint: NSLayoutConstraint?
    private weak var rightConstraint: NSLayoutConstraint?
    private weak var bottomConstraint: NSLayoutConstraint?

    convenience init(image: UIImage?, text: String?, buttonTitle: String?, buttonAction: ButtonAction?) {
        self.init()
        self.configure(image: image, text: text, buttonTitle: buttonTitle, buttonAction: buttonAction)
    }
    
    func configure(image image: UIImage?, text: String?, buttonTitle: String?, buttonAction: ButtonAction?) {
        self.image = image
        self.text = text
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if let image = image {
            self.addSubview(imageView)
            imageView.image = image
            imageView.sizeToFit()
            imageView.frame.origin.x = 8.0
            imageView.center.y = CGRectGetMidY(self.bounds)
        }
        else {
            imageView.removeFromSuperview()
        }
        
        if let buttonTitle = buttonTitle {
            self.addSubview(button)
            button.setTitle(buttonTitle, forState: .Normal)
            button.sizeToFit()
            button.frame.origin.x = CGRectGetWidth(self.frame) - 8.0 - CGRectGetWidth(button.frame)
            button.center.y = CGRectGetMidY(self.bounds)
        }
        else {
            button.removeFromSuperview()
        }

        if let text = text {
            self.addSubview(label)
            label.text = text
            label.textColor = self.tintColor
            label.sizeToFit()
            let left = (image == nil) ? 0.0 : CGRectGetMaxX(imageView.frame)
            let right = (buttonTitle == nil) ? CGRectGetWidth(self.frame) : CGRectGetMinX(button.frame)
            label.frame.origin.x = left
            label.frame.size.width = right - left - 8.0
            label.center.y = CGRectGetMidY(self.bounds)
        }
        else {
            label.removeFromSuperview()
        }
    }
}

//extension BannerView {
//    public func setState(state: State, animated: Bool, completion: (() -> Void)? = nil) {
//        guard let superview = self.view.superview, bottomConstraint = self.bottomConstraint else {
//            return
//        }
//        
//        superview.layoutIfNeeded()  // Ensures that all pending layout operations have been completed
//        
//        let (height, icon) = { s -> (CGFloat, UIImage) in
//            switch s {
//            case .Hidden:
//                return (-self.totalHeight, UIImage(named: "ic_chevron_up")!)
//            case .Banner:
//                return (-self.detailHeight, UIImage(named: "ic_chevron_up")!)
//            case .Detail:
//                return (0, UIImage(named: "ic_chevron_down")!)
//            }
//        }(state)
//        
//        bottomConstraint.constant = height
//        
//        if animated == true {
//            UIView.animateWithDuration(
//                0.2,
//                animations: {
//                    superview.layoutIfNeeded()
//                },
//                completion: { (finished) in
//                    self.updateUI()
//                    //                    self.bannerButton?.setImage(icon, forState: .Normal)
//                }
//            )
//        }
//        else {
//            self.updateUI()
//            //            self.bannerButton?.setImage(icon, forState: .Normal)
//        }
//        
//        self.state = state
//    }
//}
//
//extension BannerView {
//    func setupConstraintsAndAddToContainer(containerView: UIView) {
//        
//        containerView.addSubview(self)
//        
//        let left = NSLayoutConstraint(item: containerView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1.0, constant: 0.0)
//        let right = NSLayoutConstraint(item: containerView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1.0, constant: 0.0)
//        let bottom = NSLayoutConstraint(item: containerView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
//        containerView.addConstraints([left, right, bottom])
//        
//        // Keep references to the constraints
//        self.leftConstraint = left
//        self.rightConstraint = right
//        self.bottomConstraint = bottom
//    }
//}
//
//extension UIViewController {
//    func presentBanner(banner: BannerView, animated: Bool, completion: (() -> Void)?) {
//        banner.translatesAutoresizingMaskIntoConstraints = false
//        banner.setupConstraintsAndAddToContainer(self.view)
//        
//        banner.setState(.Hidden, animated: false)
//        banner.setState(.Banner, animated: animated, completion: completion)
//    }
//    
//    func dismissBanner(banner: WIBannerController? = nil, animated: Bool, completion: (() -> Void)?) {
//        guard let bannerOrSelf = banner ?? self as? WIBannerController else {
//            return
//        }
//        
//        if animated == true {
//            bannerOrSelf.setState(.Hidden, animated: true, completion: {
//                bannerOrSelf.willMoveToParentViewController(nil)
//                bannerOrSelf.view.removeFromSuperview()
//                bannerOrSelf.removeFromParentViewController()
//                if let completion = completion {
//                    completion()
//                }
//            })
//        }
//        else {
//            bannerOrSelf.setState(.Hidden, animated: false, completion: completion)
//            bannerOrSelf.willMoveToParentViewController(nil)
//            bannerOrSelf.view.removeFromSuperview()
//            bannerOrSelf.removeFromParentViewController()
//        }
//    }
//}
