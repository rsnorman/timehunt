//
//  DatePickerController.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 1/4/15.
//  Copyright (c) 2015 Ryan Norman. All rights reserved.
//

import Foundation

protocol DatePickerControllerDelegate {
    func didScrollDates(position: CGFloat)
}

class DatePickerController: UIViewController {
    var monthColumnView : SeasonColumnView!
    var datePickerLabel : UILabel!
    var delegate        : DatePickerControllerDelegate!
    var startScrollY  : CGFloat!
    
    override func viewDidLoad() {
        let frame = view.frame
        
        datePickerLabel = createLabel("", CGRectMake(10, 60, frame.width - 20, 120), 36)
        datePickerLabel.numberOfLines = 2
        
        monthColumnView = SeasonColumnView(labels: ["Opening Day", "Closing Day"], frame: CGRectMake(0, 230, frame.width / 2.0 - 10, frame.height - 285))
        monthColumnView.setTextAlignment(NSTextAlignment.Right)
        
        view.backgroundColor = .clearColor()
        
        view.addSubview(datePickerLabel)
        view.addSubview(monthColumnView)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: "scrollDates:")
        view.addGestureRecognizer(panGesture)
        
        view.userInteractionEnabled = true
        
        datePickerLabel.text = "Michigan\nDeer Season"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        startScrollY = 0
    }
    
    func scrollDates(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(view)
        
        if recognizer.state == UIGestureRecognizerState.Began {
            startScrollY = 0
        } else {
            delegate?.didScrollDates(translation.y - startScrollY)
            startScrollY = translation.y
        }
    }
}
