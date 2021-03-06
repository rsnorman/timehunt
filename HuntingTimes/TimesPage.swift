//
//  TimesView.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 1/3/15.
//  Copyright (c) 2015 Ryan Norman. All rights reserved.
//

import Foundation
import UIKit

class TimesPage : HuntingPageView {
    let countdownLabel : CountdownLabel
    
    required init(frame: CGRect) {
        countdownLabel = CountdownLabel(frame: CGRect(x: 0, y: 55, width: frame.width, height: 120))
        super.init(frame: frame, huntingColumnsClass: TimesColumns.self)
        messageLabel.alpha = 0.0
        addSubview(countdownLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
