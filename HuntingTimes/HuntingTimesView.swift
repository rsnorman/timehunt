//
//  HuntingTimesView.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/25/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

class HuntingTimesView : UIView {
    let eventColumnView : ColumnView
    let timeColumnView  : ColumnView
    let padding         : CGFloat = 15
    
    override init(frame: CGRect) {
        eventColumnView = ColumnView(labels: ["Start", "Sunrise", "Sunset", "Stop"], frame: CGRectMake(0, 0, frame.width / 2.0 - padding, frame.height))
        eventColumnView.setTextAlignment(NSTextAlignment.Right)
        
        timeColumnView = ColumnView(labels: [], frame: CGRectMake(frame.width / 2.0 + padding, 0, frame.width / 2.0 - padding, frame.height))
        timeColumnView.setTextAlignment(NSTextAlignment.Left)
        
        super.init(frame: frame)
        
        addSubview(eventColumnView)
        addSubview(timeColumnView)
    }
    
    func setTimes(huntingTimes: [NSDate]) {
        timeColumnView.setLabels([timeToString(huntingTimes[0]), timeToString(huntingTimes[1]), timeToString(huntingTimes[2]), timeToString(huntingTimes[3])])
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
