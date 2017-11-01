//
//  File.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 1/3/15.
//  Copyright (c) 2015 Ryan Norman. All rights reserved.
//

import Foundation
import UIKit

class HuntingPageView : UIView {
    let huntingColumnsView : HuntingColumnsView
    let stateLabel         : UILabel
    let messageLabel       : MessageView
    let mainLabel          : UILabel
    
    init(frame: CGRect, huntingColumnsClass: HuntingColumnsView.Type) {
        self.huntingColumnsView = huntingColumnsClass.init(frame: createPageViewRect(0, width: frame.width))
        
        mainLabel = createLabel("", frame: CGRect(x: 0, y: 55, width: frame.width, height: 120), fontSize: 60)
        
        messageLabel = MessageView(frame: CGRect(x: 10, y: 75, width: frame.width - 20, height: 100))
        messageLabel.alpha = 0
        stateLabel = createLabel("", frame: CGRect(x: 0, y: 30, width: frame.width, height: 40), fontSize: 16)
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
