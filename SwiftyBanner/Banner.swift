//
//  Banner.swift
//  SwiftyBanner
//
//  Created by Joseph Lin on 8/8/16.
//  Copyright © 2016 Joseph Lin All rights reserved.
//

import UIKit

public class WIBannerController : UIViewController {
    
    public enum State {
        case Hidden
        case Banner
        case Detail
    }
    
    //MARK: - Private Properties

    @IBOutlet private weak var bannerView: UIView?
    @IBOutlet private weak var bannerImageView: UIImageView?
    @IBOutlet private weak var bannerLabel: UILabel?
    @IBOutlet private weak var bannerButton: UIButton?
    @IBOutlet private weak var detailView: UIView?
    @IBOutlet private weak var detailLabel: UILabel?
    @IBOutlet private weak var detailButton: UIButton?
    
    private weak var leftConstraint: NSLayoutConstraint?
    private weak var rightConstraint: NSLayoutConstraint?
    private weak var bottomConstraint: NSLayoutConstraint?

    //MARK: Private Convenience Properties
    
    private var bannerHeight: CGFloat {
        guard let bannerView = self.bannerView else {
            return 0
        }
        return CGRectGetHeight(bannerView.frame)
    }
    
    private var detailHeight: CGFloat {
        guard let detailView = self.detailView else {
            return 0
        }
        return CGRectGetHeight(detailView.frame)
    }
    
    private var totalHeight: CGFloat {
        return CGRectGetHeight(self.view.frame)
    }
    
    //MARK: - Public Properties

    private(set) public var state: State?
    
    public var bannerIcon: UIImage? {
        didSet {
            self.bannerImageView?.image = self.bannerIcon
        }
    }
    public var bannerTitle: String? {
        didSet {
            self.bannerLabel?.text = self.bannerTitle
        }
    }
    public var detailDescription: String? {
        didSet {
            self.detailLabel?.text = self.detailDescription
        }
    }
    public var detailButtonTitle: String? {
        didSet {
            self.detailButton?.setTitle(self.detailButtonTitle, forState: .Normal)
        }
    }
    public var detailButtonAction: ((banner: WIBannerController) -> Void)?
    
    //MARK: - Private Methods

    @IBAction private func bannerButtonTapped(sender: UIButton) {
        guard let state = self.state else {
            return
        }
        switch state {
        case .Hidden:
            break
        case .Banner:
            self.setState(.Detail, animated: true)
        case .Detail:
            self.setState(.Banner, animated: true)
        }
    }
    
    @IBAction private func detailButtonTapped(sender: UIButton) {
        if let action = self.detailButtonAction {
            action(banner: self)
        }
    }
    
    func setupConstraintsAndAddToContainer(containerView: UIView) {

        containerView.addSubview(self.view)

        let left = NSLayoutConstraint(item: containerView, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0.0)
        let right = NSLayoutConstraint(item: containerView, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1.0, constant: 0.0)
        let bottom = NSLayoutConstraint(item: containerView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        containerView.addConstraints([left, right, bottom])
        
        // Keep references to the constraints
        self.leftConstraint = left
        self.rightConstraint = right
        self.bottomConstraint = bottom
    }
    
    //MARK: - Public Methods
    
    convenience init(title: String, icon: UIImage?, description: String?, buttonTitle: String?, buttonAction: ((WIBannerController) -> Void)?) {
        self.init(nibName: "Banner", bundle: nil)
        
        self.bannerTitle = title
        self.bannerIcon = icon
        self.detailDescription = description
        self.detailButtonTitle = buttonTitle
        self.detailButtonAction = buttonAction
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.bannerImageView?.image = self.bannerIcon
        self.bannerLabel?.text = self.bannerTitle
        self.detailLabel?.text = self.detailDescription
        self.detailButton?.setTitle(self.detailButtonTitle, forState: .Normal)
    }

    public func setState(state: State, animated: Bool, completion: (() -> Void)? = nil) {
        guard let superview = self.view.superview, bottomConstraint = self.bottomConstraint else {
            return
        }
        
        superview.layoutIfNeeded()  // Ensures that all pending layout operations have been completed
        
        let (height, icon) = { s -> (CGFloat, UIImage) in
            switch s {
            case .Hidden:
                return (-self.totalHeight, UIImage(named: "ic_chevron_up")!)
            case .Banner:
                return (-self.detailHeight, UIImage(named: "ic_chevron_up")!)
            case .Detail:
                return (0, UIImage(named: "ic_chevron_down")!)
            }
        }(state)

        bottomConstraint.constant = height
        
        if animated == true {
            UIView.animateWithDuration(
                0.2,
                animations: {
                    superview.layoutIfNeeded()
                },
                completion: { (finished) in
                    self.bannerButton?.setImage(icon, forState: .Normal)
                }
            )
        }
        else {
            self.bannerButton?.setImage(icon, forState: .Normal)
        }
        
        self.state = state
    }
}

//MARK: -

extension UIViewController {
    func presentBanner(banner: WIBannerController, animated: Bool, completion: (() -> Void)?) {
        self.addChildViewController(banner)
        banner.view.translatesAutoresizingMaskIntoConstraints = false
        banner.setupConstraintsAndAddToContainer(self.view)
        banner.didMoveToParentViewController(self)

        banner.setState(.Hidden, animated: false)
        banner.setState(.Banner, animated: animated, completion: completion)
    }
    
    func dismissBanner(banner: WIBannerController? = nil, animated: Bool, completion: (() -> Void)?) {
        guard let bannerOrSelf = banner ?? self as? WIBannerController else {
            return
        }
        
        if animated == true {
            bannerOrSelf.setState(.Hidden, animated: true, completion: {
                bannerOrSelf.willMoveToParentViewController(nil)
                bannerOrSelf.view.removeFromSuperview()
                bannerOrSelf.removeFromParentViewController()
                if let completion = completion {
                    completion()
                }
            })
        }
        else {
            bannerOrSelf.setState(.Hidden, animated: false, completion: completion)
            bannerOrSelf.willMoveToParentViewController(nil)
            bannerOrSelf.view.removeFromSuperview()
            bannerOrSelf.removeFromParentViewController()
        }
    }
}
