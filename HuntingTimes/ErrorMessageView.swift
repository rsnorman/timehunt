//
//  ErrorMessageView.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 3/8/15.
//  Copyright (c) 2015 Ryan Norman. All rights reserved.
//

import UIKit

class ErrorMessageView : UIView {
    let messageLabel : UILabel
    var actionSource : AnyObject!
    var action       : Selector!
    
    override init(frame: CGRect) {
        messageLabel = createLabel("Could not load hunting weather\nTap to retry", CGRectMake(0, 0, frame.width, frame.height), 22)
        messageLabel.numberOfLines = 2
        
        super.init(frame: frame)
        
        userInteractionEnabled = true
        
        addSubview(messageLabel)
    }
    
    func setMessage(message: String) {
        messageLabel.text = message
    }
    
    func setRetryAction(actionSource : AnyObject, action: Selector) {
        gestureRecognizers = []
        let retryTap = UITapGestureRecognizer(target: actionSource, action: action)
        addGestureRecognizer(retryTap)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
