//
//  HuntingColumnsView.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 1/3/15.
//  Copyright (c) 2015 Ryan Norman. All rights reserved.
//

import Foundation

class HuntingColumnsView : UIView {
    var huntingDay : HuntingDay!
    
    override required init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDay(huntingDay: HuntingDay) {
        self.huntingDay = huntingDay
    }
}