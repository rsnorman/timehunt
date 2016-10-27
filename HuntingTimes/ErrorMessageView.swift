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
        messageLabel = createLabel("Could not load hunting weather\nTap to retry", frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), fontSize: 22)
        messageLabel.numberOfLines = 2
        
        super.init(frame: frame)
        
        isUserInteractionEnabled = true
        
        addSubview(messageLabel)
    }
    
    func setMessage(_ message: String) {
        messageLabel.text = message
    }
    
    func setRetryAction(_ actionSource : AnyObject, action: Selector) {
        gestureRecognizers = []
        let retryTap = UITapGestureRecognizer(target: actionSource, action: action)
        addGestureRecognizer(retryTap)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
