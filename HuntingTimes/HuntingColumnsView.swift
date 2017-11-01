//
//  HuntingColumnsView.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 1/3/15.
//  Copyright (c) 2015 Ryan Norman. All rights reserved.
//

import Foundation
import UIKit

class HuntingColumnsView : UIView {
    var huntingDay       : HuntingDay!
    let leftColumnView   : ColumnView
    let rightColumnView  : ColumnView
    let padding          : CGFloat = 15
    
    override required init(frame: CGRect) {
        leftColumnView = ColumnView(labels: [], frame: CGRect(x: 0, y: 0, width: frame.width / 2.0 - padding, height: frame.height))
        leftColumnView.setColumnTextAlignment(NSTextAlignment.right)
        
        rightColumnView = ColumnView(labels: [], frame: CGRect(x: frame.width / 2.0 + padding, y: 0, width: frame.width / 2.0 - padding, height: frame.height))
        rightColumnView.setColumnTextAlignment(NSTextAlignment.left)
        
        super.init(frame: frame)
        
        addSubview(leftColumnView)
        addSubview(rightColumnView)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDay(_ huntingDay: HuntingDay) {
        self.huntingDay = huntingDay
    }
}
