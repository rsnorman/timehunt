//
//  TiltImageView.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/22/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//


import UIKit
import CoreMotion

class TiltImageView: UIImageView {
    let scrollView: UIScrollView
    let motionManager = CMMotionManager()
    
    init(image: UIImage, frame: CGRect) {
        scrollView = UIScrollView(frame: frame)
        super.init(frame: frame)
        
        var imageView = UIImageView(image: image)
        var imageWidth = frame.height * image.size.width / image.size.height
        imageView.frame = CGRectMake((frame.width - imageWidth) / 2, 0, imageWidth, scrollView.frame.height)
        scrollView.addSubview(imageView)
        addSubview(scrollView)
        
        initMotionManager()
    }
    
    func setImage(image : UIImage) {
        let currentSubviews = scrollView.subviews
        
        var imageView = UIImageView(image: image)
        var imageWidth = frame.height * image.size.width / image.size.height
        imageView.frame = CGRectMake((frame.width - imageWidth) / 2, 0, imageWidth, scrollView.frame.height)
        imageView.alpha = 0.0
        scrollView.addSubview(imageView)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.scrollView.addSubview(imageView)
            imageView.alpha = 1.0
        }) { (complete) -> Void in
            for view in currentSubviews as [UIView] {
                view.removeFromSuperview()
            }
        }
    }
    
    deinit {
        motionManager.stopDeviceMotionUpdates()
    }
    
    func initMotionManager() {
        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.currentQueue(), withHandler:{
            deviceManager, error in
            
            var xRotationRate = deviceManager.rotationRate.x
            var yRotationRate = deviceManager.rotationRate.y
            var zRotationRate = deviceManager.rotationRate.z
            if (fabs(yRotationRate) > (fabs(xRotationRate) + fabs(zRotationRate)))
            {
                let kRotationMultiplier = 0.4;
                let invertedYRotationRate = yRotationRate * -1;
                
                let interpretedXOffset = Double(self.scrollView.contentOffset.x) + (invertedYRotationRate * kRotationMultiplier)
                let contentOffset = self.clampedContentOffsetForHorizontalOffset(CGFloat(interpretedXOffset))
                
                let kMovementSmoothing = 0.3
                UIView.animateWithDuration(kMovementSmoothing, delay: 0.0, options: UIViewAnimationOptions.BeginFromCurrentState|UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    self.scrollView.contentOffset = contentOffset
                    }, completion: { (complete) -> Void in
                        
                })
            }
        })
    }
    
    func clampedContentOffsetForHorizontalOffset(horizontalOffset: CGFloat) -> CGPoint {
        let minimumXOffset: CGFloat = scrollView.contentSize.width - CGRectGetWidth(scrollView.bounds)
        let maximumXOffset: CGFloat = minimumXOffset * -1
        let clampedXOffset = fmax(minimumXOffset, fmin(horizontalOffset, maximumXOffset))
        let centeredY: CGFloat = scrollView.contentOffset.y
        
        return CGPointMake(clampedXOffset, centeredY)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

