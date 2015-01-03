//
//  File.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 1/3/15.
//  Copyright (c) 2015 Ryan Norman. All rights reserved.
//

import Foundation

class HuntingPageView : UIView {
    let huntingColumnsView : HuntingColumnsView
    let dateLabel          : UILabel
    let stateLabel         : UILabel
    let messageLabel       : MessageView
    
    init(frame: CGRect, huntingColumnsClass: HuntingColumnsView.Type) {
        self.huntingColumnsView = huntingColumnsClass(frame: CGRectMake(0, 230, frame.width, frame.height - 285))
        
        messageLabel = MessageView(frame: CGRectMake(10, 75, frame.width - 20, 100))
        stateLabel = createLabel("", CGRectMake(0, 30, frame.width, 40), 16)
        stateLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        dateLabel = createLabel("", CGRectMake(0, 200, frame.width, 30), 18)
        
        super.init(frame: frame)
        
        addSubview(messageLabel)
        addSubview(stateLabel)
        addSubview(dateLabel)
        addSubview(huntingColumnsView)
    }
    
    required override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
