//
//  DatePickerController.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 1/4/15.
//  Copyright (c) 2015 Ryan Norman. All rights reserved.
//

import Foundation

protocol DatePickerControllerDelegate {
    func didScrollDates(_ position: CGFloat)
}

class DatePickerController: UIViewController, UIScrollViewDelegate {
    var monthColumnView : SeasonColumnView!
    var datePickerLabel : UILabel!
    var delegate        : DatePickerControllerDelegate!
    var scrollView      : UIScrollView!
    
    override func viewDidLoad() {
        let frame = view.frame
        
        datePickerLabel = createLabel("", frame: CGRect(x: 10, y: 60, width: frame.width - 20, height: 120), fontSize: 36)
        datePickerLabel.numberOfLines = 2
        
        monthColumnView = SeasonColumnView(labels: ["Opening Day", "Closing Day"], frame: createPageViewRect(0, width: frame.width / 2.0 - 10))
        monthColumnView.setColumnTextAlignment(NSTextAlignment.right)
        
        view.backgroundColor = .clear
        view.addSubview(datePickerLabel)
        view.addSubview(monthColumnView)
        view.isUserInteractionEnabled = true
        
        datePickerLabel.text = "Michigan\nDeer Season"
        
        scrollView = UIScrollView(frame: createPageViewRect(0, width: frame.width))
        scrollView.contentSize = CGSize(width: view.frame.width, height: scrollView.frame.height * 2)
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var pos = scrollView.contentOffset.y
        
        if pos < 0 {
            pos = 0
        } else if pos > scrollView.frame.height {
            pos = scrollView.frame.height
        }
        
        delegate?.didScrollDates(pos / scrollView.frame.height)
    }
}
