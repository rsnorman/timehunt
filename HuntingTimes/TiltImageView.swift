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
        
        let imageView = UIImageView(image: image)
        let imageWidth = frame.height * image.size.width / image.size.height
        imageView.frame = CGRect(x: (frame.width - imageWidth) / 2, y: 0, width: imageWidth, height: scrollView.frame.height)
        scrollView.addSubview(imageView)
        addSubview(scrollView)
        
        initMotionManager()
    }
    
    func setTiltImage(_ image : UIImage) {
        let currentSubviews = scrollView.subviews
        
        let imageView = UIImageView(image: image)
        let imageWidth = frame.height * image.size.width / image.size.height
        imageView.frame = CGRect(x: (frame.width - imageWidth) / 2, y: 0, width: imageWidth, height: scrollView.frame.height)
        imageView.alpha = 0.0
        scrollView.addSubview(imageView)
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.scrollView.addSubview(imageView)
            imageView.alpha = 1.0
        }, completion: { (complete) -> Void in
            for view in currentSubviews as [UIView] {
                view.removeFromSuperview()
            }
        }) 
    }
    
    deinit {
        motionManager.stopDeviceMotionUpdates()
    }
    
    func initMotionManager() {
        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler:{
            deviceManager, error in
            
            let xRotationRate = deviceManager?.rotationRate.x
            let yRotationRate = deviceManager?.rotationRate.y
            let zRotationRate = deviceManager?.rotationRate.z
            if (fabs(yRotationRate!) > (fabs(xRotationRate!) + fabs(zRotationRate!)))
            {
                let kRotationMultiplier = 0.4;
                let invertedYRotationRate = yRotationRate! * -1;
                
                let interpretedXOffset = Double(self.scrollView.contentOffset.x) + (invertedYRotationRate * kRotationMultiplier)
                let contentOffset = self.clampedContentOffsetForHorizontalOffset(CGFloat(interpretedXOffset))
                
                let kMovementSmoothing = 0.3
                
                UIView.animate(withDuration: kMovementSmoothing, delay: 0.0, options: [.beginFromCurrentState, .curveEaseOut], animations: {
                        self.scrollView.contentOffset = contentOffset
                    })
                
            }
        })
    }
    
    func clampedContentOffsetForHorizontalOffset(_ horizontalOffset: CGFloat) -> CGPoint {
        let minimumXOffset: CGFloat = scrollView.contentSize.width - scrollView.bounds.width
        let maximumXOffset: CGFloat = minimumXOffset * -1
        let clampedXOffset = fmax(minimumXOffset, fmin(horizontalOffset, maximumXOffset))
        let centeredY: CGFloat = scrollView.contentOffset.y
        
        return CGPoint(x: clampedXOffset, y: centeredY)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

