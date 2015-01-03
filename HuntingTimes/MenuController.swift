//
//  MenuView.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 12/3/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

protocol MenuControllerDelegate {
    func didSelectBackground(backgroundImage: String)
}

class MenuController : UIViewController {
    
    let backgroundImages = ["dark-forest.jpg", "leaves-forest.jpg", "forest.jpg"]
    var backgroundView     : UIView!
    var imageViews         : [UIImageView]!
    var selectedBackground : String!
    var delegate           : MenuControllerDelegate!
    
    override func viewDidLoad() {
        view.alpha = 0.0
        
        backgroundView = UIView(frame: view.frame)
        backgroundView.backgroundColor = .blackColor()
        backgroundView.alpha           = 0.8
        view.addSubview(backgroundView)
        
        let backgroundLabel = UILabel(frame: CGRectMake(0, 170, view.frame.width, 20))
        backgroundLabel.text = "Choose Background"
        backgroundLabel.textColor = .whiteColor()
        backgroundLabel.font = UIFont.systemFontOfSize(18)
        backgroundLabel.textAlignment = .Center
        view.addSubview(backgroundLabel)
        
        imageViews = []
        for (index, backgroundImage) in enumerate(backgroundImages) {
            let imageView                     = UIImageView(frame: CGRectMake(10 + (115 * CGFloat(index)), 210, 70, 70))
            imageView.image                   = UIImage(named: backgroundImage)
            imageView.layer.borderColor       = UIColor(white: 1, alpha: 1).CGColor
            imageView.layer.borderWidth       = 2.0
            imageView.layer.cornerRadius      = 35
            imageView.clipsToBounds           = true
            imageView.accessibilityIdentifier = backgroundImage
            imageView.userInteractionEnabled  = true
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "selectBackgroundImage:"))
            imageViews.append(imageView)
            view.addSubview(imageView)
        }
    }
    
    override func viewDidAppear(animate: Bool) {
        UIView.animateWithDuration(0.4) {
            self.view.alpha = 1.0
            
            if let selectedBG = self.selectedBackground {
                for (index, imageView) in enumerate(self.imageViews) {
                    imageView.layer.borderColor  = UIColor(white: 1, alpha: selectedBG == imageView.accessibilityIdentifier ? 1 : 0.3).CGColor
                }
            }
        }
    }
    
    func selectBackgroundImage(sender : UITapGestureRecognizer) {
        if let view = sender.view {
            selectedBackground = view.accessibilityIdentifier
            
            UIView.animateWithDuration(1.0) {
                for (index, imageView) in enumerate(self.imageViews) {
                    imageView.layer.borderColor  = UIColor(white: 1, alpha: self.selectedBackground == imageView.accessibilityIdentifier ? 1 : 0.3).CGColor
                }
            }

            delegate?.didSelectBackground(selectedBackground)
        }
    }
}