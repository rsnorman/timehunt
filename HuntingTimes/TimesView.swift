//
//  TimesView.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 1/3/15.
//  Copyright (c) 2015 Ryan Norman. All rights reserved.
//

import Foundation

class TimesView : UIView {
    let countdownLabel     : CountdownView
    let dateLabel          : UILabel
    let huntingTimesView   : HuntingTimesView
    let stateLabel         : UILabel
    let messageLabel       : MessageView
    
    override init(frame: CGRect) {
        
        messageLabel = MessageView(frame: CGRectMake(10, 75, frame.width - 20, 100))
        messageLabel.alpha    = 0.0
        
        stateLabel = createLabel("", CGRectMake(0, 30, frame.width, 40), 16)
        stateLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        stateLabel.alpha = 1
        
        countdownLabel = CountdownView(frame: CGRectMake(0, 55, frame.width, 120))
        countdownLabel.alpha = 1
        
        dateLabel             = createLabel("", CGRectMake(0, 200, frame.width, 30), 18)
        dateLabel.alpha       = 1
        
        huntingTimesView = HuntingTimesView(frame: CGRectMake(0, 230, frame.width, frame.height - 285))
        huntingTimesView.alpha = 1
        
        super.init(frame: frame)
        
        addSubview(messageLabel)
        addSubview(stateLabel)
        addSubview(countdownLabel)
        addSubview(dateLabel)
        addSubview(huntingTimesView)
    }
    
//    func setDelegate(viewController: ViewController) {
//        messageLabel.delegate     = viewController as MessageViewDelegate
//        countdownLabel.delegate   = viewController as CountdownViewDelegate
//        huntingTimesView.delegate = viewController as HuntingTimesViewDelegate
//    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}