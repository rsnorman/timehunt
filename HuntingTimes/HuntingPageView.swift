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
    let stateLabel         : UILabel
    let messageLabel       : MessageView
    let mainLabel          : UILabel
    
    init(frame: CGRect, huntingColumnsClass: HuntingColumnsView.Type) {
        self.huntingColumnsView = huntingColumnsClass(frame: createPageViewRect(0, frame.width))
        
        mainLabel = createLabel("", CGRectMake(0, 55, frame.width, 120), 60)
        
        messageLabel = MessageView(frame: CGRectMake(10, 75, frame.width - 20, 100))
        messageLabel.alpha = 0
        stateLabel = createLabel("", CGRectMake(0, 30, frame.width, 40), 16)
        stateLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        
        super.init(frame: frame)
        
        addSubview(mainLabel)
        addSubview(messageLabel)
        addSubview(stateLabel)
        addSubview(huntingColumnsView)
    }
    
    required override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
