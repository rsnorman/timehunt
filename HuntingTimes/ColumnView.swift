//
//  LabelColumn.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/24/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

class ColumnView : UIView {
    var textAlignment : NSTextAlignment
    let labels        : [String]
    
    init(labels: [String], frame: CGRect) {
        textAlignment = .Center
        self.labels   = labels
        
        super.init(frame: frame)
        
        setLabels(labels)
    }
    
    func setTextAlignment(alignment: NSTextAlignment) {
        textAlignment = alignment
        for label in self.subviews as [UILabel] {
            label.textAlignment = alignment
        }
    }
    
    func setLabels(labels: [String]) {
        let offset      = frame.height / CGFloat(labels.count)
        let startOffset = offset / 2.0
        
        for view in self.subviews as [UIView] {
            view.removeFromSuperview()
        }
        
        for (index, text) in enumerate(labels) {
            let label = UILabel(frame: CGRectMake(0, 0, frame.width, 30))
            label.text          = text
            label.textColor     = .whiteColor()
            label.font          = UIFont(name: "HelveticaNeue-Thin", size: 28)
            label.textAlignment = textAlignment
            label.center        = CGPointMake(label.center.x, startOffset + (offset * CGFloat(index)))
            addSubview(label)
        }
    }
    
    func getPosition(labelText: String) -> CGPoint? {
        for label in subviews as [UILabel] {
            if label.text == labelText {
                return label.center
            }
        }
        
        return nil
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
