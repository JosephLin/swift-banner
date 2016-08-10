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

    weak var imageView: UIImageView?
    weak var label: UILabel?
    weak var button: UIButton?
    
    weak var labelConstraintLeft: NSLayoutConstraint?
    weak var labelConstraintRight: NSLayoutConstraint?
    
    @IBInspectable var image: UIImage? {
        didSet {
            self.updateUI()
        }
    }
    @IBInspectable var text: String? {
        didSet {
            self.updateUI()
        }
    }
    @IBInspectable var buttonTitle: String? {
        didSet {
            self.updateUI()
        }
    }
    var buttonAction: ButtonAction?
    
    convenience init(image: UIImage?, text: String?, buttonTitle: String?, buttonAction: ButtonAction?) {
        self.init()
        self.configure(image: image, text: text, buttonTitle: buttonTitle, buttonAction: buttonAction)
    }
    
    func configure(image image: UIImage?, text: String?, buttonTitle: String?, buttonAction: ButtonAction?) {
        self.image = image
        self.text = text
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
        self.updateUI()
    }
    
    func updateUI() {

        if let image = image {
            let imageView = self.imageView ?? {
                let imageView = UIImageView()
                self.imageView = imageView

                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
                self.addSubview(imageView)
                self.addConstraints([
                    NSLayoutConstraint(item: imageView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 8.0),
                    NSLayoutConstraint(item: imageView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0),
                    ])
                
                return imageView
                }()

            imageView.image = image
        }
        else {
            self.imageView?.removeFromSuperview()
        }
        
        if let buttonTitle = buttonTitle {
            let button = self.button ?? {
                let button = UIButton()
                self.button = button

                button.translatesAutoresizingMaskIntoConstraints = false
                button.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
                self.addSubview(button)
                self.addConstraints([
                    NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal, toItem: button, attribute: .Trailing, multiplier: 1.0, constant: 8.0),
                    NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: button, attribute: .CenterY, multiplier: 1.0, constant: 0.0),
                    ])

                return button
                }()
            
            button.setTitle(buttonTitle, forState: .Normal)
        }
        else {
            self.button?.removeFromSuperview()
        }
        
        if let text = text {
            let label = self.label ?? {
                let label = UILabel()
                self.label = label

                label.translatesAutoresizingMaskIntoConstraints = false
                label.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
                self.addSubview(label)
                self.addConstraint(NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: label, attribute: .CenterY, multiplier: 1.0, constant: 0.0))

                return label
                }()
            
            if let labelConstraintLeft = labelConstraintLeft {
                self.removeConstraint(labelConstraintLeft)
            }
            let leftItem = imageView ?? self
            let leftConstraint = NSLayoutConstraint(item: label, attribute: .Leading, relatedBy: .Equal, toItem: leftItem, attribute: .Trailing, multiplier: 1.0, constant: 8.0)
            labelConstraintLeft = leftConstraint
            self.addConstraint(leftConstraint)

            if let labelConstraintRight = labelConstraintRight {
                self.removeConstraint(labelConstraintRight)
            }
            let rightItem = button ?? self
            let rightConstraint = NSLayoutConstraint(item: rightItem, attribute: .Leading, relatedBy: .Equal, toItem: label, attribute: .Trailing, multiplier: 1.0, constant: 8.0)
            labelConstraintRight = rightConstraint
            self.addConstraint(rightConstraint)

            label.text = text
        }
        else {
            self.label?.removeFromSuperview()
        }
    }
}
