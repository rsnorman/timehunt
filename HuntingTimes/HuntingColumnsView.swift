//
//  HuntingColumnsView.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 1/3/15.
//  Copyright (c) 2015 Ryan Norman. All rights reserved.
//

import Foundation

class HuntingColumnsView : UIView {
    var huntingDay       : HuntingDay!
    let leftColumnView   : ColumnView
    let rightColumnView  : ColumnView
    let padding          : CGFloat = 15
    
    override required init(frame: CGRect) {
        leftColumnView = ColumnView(labels: [], frame: CGRectMake(0, 0, frame.width / 2.0 - padding, frame.height))
        leftColumnView.setTextAlignment(NSTextAlignment.Right)
        
        rightColumnView = ColumnView(labels: [], frame: CGRectMake(frame.width / 2.0 + padding, 0, frame.width / 2.0 - padding, frame.height))
        rightColumnView.setTextAlignment(NSTextAlignment.Left)
        
        super.init(frame: frame)
        
        addSubview(leftColumnView)
        addSubview(rightColumnView)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDay(huntingDay: HuntingDay) {
        self.huntingDay = huntingDay
    }
}