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
    
    override func viewDidLoad() {
        let frame = view.frame
        
        datePickerLabel = createLabel("", CGRectMake(10, 60, frame.width - 20, 120), 36)
        datePickerLabel.numberOfLines = 2
        
        monthColumnView = SeasonColumnView(labels: ["Opening Day", "Closing Day"], frame: createPageViewRect(0, frame.width / 2.0 - 10))
        monthColumnView.setTextAlignment(NSTextAlignment.Right)
        
        view.backgroundColor = .clearColor()
        view.addSubview(datePickerLabel)
        view.addSubview(monthColumnView)
        view.userInteractionEnabled = true
        
        datePickerLabel.text = "Michigan\nDeer Season"
        
        scrollView = UIScrollView(frame: createPageViewRect(0, frame.width))
        scrollView.contentSize = CGSize(width: view.frame.width, height: scrollView.frame.height * 2)
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var pos = scrollView.contentOffset.y
        
        if pos < 0 {
            pos = 0
        } else if pos > scrollView.frame.height {
            pos = scrollView.frame.height
        }
        
        delegate?.didScrollDates(pos / scrollView.frame.height)
    }
}
