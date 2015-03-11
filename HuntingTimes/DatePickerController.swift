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

class DatePickerController: UIViewController, UIScrollViewDelegate {
    var monthColumnView : SeasonColumnView!
    var datePickerLabel : UILabel!
    var delegate        : DatePickerControllerDelegate!
    var scrollView      : UIScrollView!
    var startScrollY    : CGFloat!
    
    override func viewDidLoad() {
        let frame = view.frame
        
        datePickerLabel = createLabel("", CGRectMake(10, 60, frame.width - 20, 120), 36)
        datePickerLabel.numberOfLines = 2
        
        monthColumnView = SeasonColumnView(labels: ["Opening Day", "Closing Day"], frame: createPageViewRect(0, frame.width / 2.0 - 10))
        monthColumnView.setTextAlignment(NSTextAlignment.Right)
        
        view.backgroundColor = .clearColor()
        
        view.addSubview(datePickerLabel)
        view.addSubview(monthColumnView)
        
//        let panGesture = UIPanGestureRecognizer(target: self, action: "scrollDates:")
//        view.addGestureRecognizer(panGesture)
        
        view.userInteractionEnabled = true
        
        datePickerLabel.text = "Michigan\nDeer Season"
        
        scrollView = UIScrollView(frame: createPageViewRect(0, frame.width))
        scrollView.contentSize = CGSize(width: view.frame.width, height: 3000)
        scrollView.layer.borderColor = UIColor.whiteColor().CGColor
        scrollView.layer.borderWidth = 1
        scrollView.delegate = self
//        [tableView setShowsHorizontalScrollIndicator:NO];
//        [tableView setShowsVerticalScrollIndicator:NO];
        view.addSubview(scrollView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        startScrollY = 0
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        println(scrollView.contentOffset.y)
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
