//
//  DatePickerController.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 1/4/15.
//  Copyright (c) 2015 Ryan Norman. All rights reserved.
//

import Foundation

class DatePickerController: UIViewController {
    var monthColumnView    : ColumnView!
    var datepickerLabel    : UILabel!
    
    override func viewDidLoad() {
        let frame = view.frame
        
        datepickerLabel = createLabel("", CGRectMake(0, 60, frame.width, 120), 48)
        
        monthColumnView = ColumnView(labels: ["September", "October", "November", "December"], frame: CGRectMake(0, 230, frame.width / 2.0 - 10, frame.height - 285))
        monthColumnView.setTextAlignment(NSTextAlignment.Right)
        
        view.backgroundColor = .clearColor()
        
        view.addSubview(datepickerLabel)
        view.addSubview(monthColumnView)
    }
    
    func setDate(date: NSDate) {
        datepickerLabel.text = dateToString(date)
    }
}
