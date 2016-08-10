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
    
    enum Style {
        case BannerOnly
        case BannerWithButton
        case BannerWithDetail
        case BannerWithDetailAndButton
    }
    
    public typealias ButtonAction = (WIBannerController) -> Void
    public typealias LabelConfig = (UILabel) -> Void
    public typealias ImageViewConfig = (UIImageView) -> Void
    public typealias ButtonConfig = (button: (UIButton) -> Void, action: ButtonAction)
    
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

    private var iconConfig: ImageViewConfig?
    private var titleConfig: LabelConfig?
    private var descriptionConfig: LabelConfig?
    private var buttonConfig: ButtonConfig?

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
        return self.detailHeight + self.bannerHeight
    }

    private var style: Style {
        if descriptionConfig != nil && buttonConfig != nil {
            return .BannerWithDetailAndButton
        }
        else if descriptionConfig != nil {
            return .BannerWithDetail
        }
        else if buttonConfig != nil {
            return .BannerWithButton
        }
        else {
            return .BannerOnly
        }
    }
    
    //MARK: - Public Properties

    private(set) public var state: State?
    
    //MARK: - Private Methods

    @IBAction private func bannerTapped(sender: UITapGestureRecognizer) {
        switch self.style {
        case .BannerOnly:
            break
        case .BannerWithButton:
            break
        case .BannerWithDetail:
            self.toggleDetail()
        case .BannerWithDetailAndButton:
            self.toggleDetail()
        }
    }
    
    @IBAction private func bannerButtonTapped(sender: UIButton) {
        switch self.style {
        case .BannerOnly:
            break
        case .BannerWithButton:
            if let buttonConfig = buttonConfig {
                buttonConfig.action(self)
            }
        case .BannerWithDetail:
            self.toggleDetail()
        case .BannerWithDetailAndButton:
            self.toggleDetail()
        }
    }
    
    @IBAction private func detailButtonTapped(sender: UIButton) {
        switch self.style {
        case .BannerOnly:
            break
        case .BannerWithButton:
            break
        case .BannerWithDetail:
            break
        case .BannerWithDetailAndButton:
            if let buttonConfig = buttonConfig {
                buttonConfig.action(self)
            }
        }
    }
    
    private func toggleDetail() {
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

    private func updateUI() {
        guard let bannerImageView = bannerImageView, bannerLabel = bannerLabel, bannerButton = bannerButton, detailLabel = detailLabel, detailButton = detailButton else {
            // View hasn't been loaded yet.
            return
        }
        
        if let iconConfig = iconConfig {
            iconConfig(bannerImageView)
        }

        if let titleConfig = titleConfig {
            titleConfig(bannerLabel)
        }
        
        if let descriptionConfig = descriptionConfig {
            descriptionConfig(detailLabel)
        }

        switch self.style {
        case .BannerOnly:
            bannerButton.setTitle(nil, forState: .Normal)
            bannerButton.setImage(nil, forState: .Normal)
            bannerButton.enabled = false
            
        case .BannerWithButton:
            buttonConfig!.button(bannerButton)
            bannerButton.enabled = true
            
        case .BannerWithDetail:
            bannerButton.setTitle(nil, forState: .Normal)
            if let state = state where state == .Detail {
                bannerButton.setImage(UIImage(named: "ic_chevron_down"), forState: .Normal)
            }
            else {
                bannerButton.setImage(UIImage(named: "ic_chevron_up"), forState: .Normal)
            }
            bannerButton.enabled = true
            detailButton.setTitle(nil, forState: .Normal)
            detailButton.setImage(nil, forState: .Normal)
            detailButton.enabled = false
            
        case .BannerWithDetailAndButton:
            bannerButton.setTitle(nil, forState: .Normal)
            if let state = state where state == .Detail {
                bannerButton.setImage(UIImage(named: "ic_chevron_down"), forState: .Normal)
            }
            else {
                bannerButton.setImage(UIImage(named: "ic_chevron_up"), forState: .Normal)
            }
            bannerButton.enabled = true
            buttonConfig!.button(detailButton)
            detailButton.enabled = true
        }
    }
    
    //MARK: - Public Methods
    
    convenience init() {
        self.init(nibName: "Banner", bundle: nil)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateUI()
    }
    
    public func configure(icon iconConfig: ImageViewConfig?, title titleConfig: LabelConfig?, description descriptionConfig: LabelConfig?, button buttonConfig: ButtonConfig?) {
        self.iconConfig = iconConfig
        self.titleConfig = titleConfig
        self.descriptionConfig = descriptionConfig
        self.buttonConfig = buttonConfig
        
        self.updateUI()
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
                    self.updateUI()
//                    self.bannerButton?.setImage(icon, forState: .Normal)
                }
            )
        }
        else {
            self.updateUI()
//            self.bannerButton?.setImage(icon, forState: .Normal)
        }
        
        self.state = state
    }
}

//MARK: -

extension WIBannerController {
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
}

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
