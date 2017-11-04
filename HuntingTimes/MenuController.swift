//
//  MenuView.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 12/3/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

protocol MenuControllerDelegate {
    func didSelectBackground(_ backgroundImage: String)
}

class MenuController : UIViewController {
    
    let backgroundImages = ["dark-forest.jpg", "leaves-forest.jpg", "forest.jpg"]
    var backgroundView     : UIView!
    var imageViews         : [UIImageView]!
    var selectedBackground : String!
    var delegate           : MenuControllerDelegate!
    let imageSize          : CGFloat = 70.0
    let imageMargin        : CGFloat = 45.0
    
    override func viewDidLoad() {
        view.alpha = 0.0
        
        backgroundView = UIView(frame: view.frame)
        backgroundView.backgroundColor = .black
        backgroundView.alpha           = 0.8
        view.addSubview(backgroundView)
        
        let backgroundLabel = UILabel(frame: CGRect(x: 0, y: 170, width: view.frame.width, height: 20))
        backgroundLabel.text = "Choose Background"
        backgroundLabel.textColor = .white
        backgroundLabel.font = UIFont.systemFont(ofSize: 18)
        backgroundLabel.textAlignment = .center
        view.addSubview(backgroundLabel)
        
        imageViews = []
        var index = 0
        let initialStartXPos = self.calcuateInitialStartXPos()

        for backgroundImage in backgroundImages {
            let imageView                     = UIImageView(frame: CGRect(x: initialStartXPos + (imageMargin + imageSize) * CGFloat(index), y: 210, width: imageSize, height: imageSize))

            imageView.image                   = UIImage(named: backgroundImage)
            imageView.layer.borderColor       = UIColor(white: 1, alpha: 1).cgColor
            imageView.layer.borderWidth       = 2.0
            imageView.layer.cornerRadius      = 35
            imageView.clipsToBounds           = true
            imageView.accessibilityIdentifier = backgroundImage
            imageView.isUserInteractionEnabled  = true
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MenuController.selectBackgroundImage(_:))))
            imageViews.append(imageView)
            view.addSubview(imageView)
            index += 1
        }
    }
    
    override func viewDidAppear(_ animate: Bool) {
        UIView.animate(withDuration: 0.4, animations: {
            self.view.alpha = 1.0
            
            if let selectedBG = self.selectedBackground {
                for imageView in self.imageViews {
                    imageView.layer.borderColor  = UIColor(white: 1, alpha: selectedBG == imageView.accessibilityIdentifier ? 1 : 0.3).cgColor
                }
            }
        }) 
    }
    
    @objc func selectBackgroundImage(_ sender : UITapGestureRecognizer) {
        if let view = sender.view {
            selectedBackground = view.accessibilityIdentifier
            
            UIView.animate(withDuration: 1.0, animations: {
                for imageView in self.imageViews {
                    imageView.layer.borderColor  = UIColor(white: 1, alpha: self.selectedBackground == imageView.accessibilityIdentifier ? 1 : 0.3).cgColor
                }
            }) 

            delegate?.didSelectBackground(selectedBackground)
        }
    }

    fileprivate

    func calcuateInitialStartXPos() -> CGFloat {
        let imageCount = CGFloat(backgroundImages.count)
        return (view.frame.width - (imageSize * imageCount + (imageMargin * (imageCount - 1)))) / 2.0
    }
}
