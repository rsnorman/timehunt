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
        textAlignment = .center
        self.labels   = labels
        
        super.init(frame: frame)
        
        setLabels(labels)
    }
    
    func setColumnTextAlignment(_ alignment: NSTextAlignment) {
        textAlignment = alignment
        for label in self.subviews as! [UILabel] {
            setPositionOfLabel(label)
        }
    }
    
    func setLabels(_ labels: [String]) {
        let offset      = frame.height / CGFloat(labels.count)
        let startOffset = offset / 2.0
        
        for view in self.subviews as [UIView] {
            view.removeFromSuperview()
        }
        
        var index = 0
        for text in labels {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: 35))
            label.text              = text
            label.textColor         = .white
            label.font              = UIFont(name: "HelveticaNeue-Thin", size: 28)
            label.center            = CGPoint(x: label.center.x, y: startOffset + (offset * CGFloat(index)))
            label.sizeToFit()
            setPositionOfLabel(label)
            addSubview(label)
            index += 1
        }
    }
    
    func setPositionOfLabel(_ label: UILabel) {
        let lFrame = label.frame
        if NSTextAlignment.center == textAlignment {
            label.center = CGPoint(x: frame.width / 2, y: label.center.y)
        } else if NSTextAlignment.left == textAlignment {
            label.frame = CGRect(x: 0, y: lFrame.origin.y, width: lFrame.width, height: lFrame.height)
        } else {
            label.frame = CGRect(x: frame.width - lFrame.width, y: lFrame.origin.y, width: lFrame.width, height: lFrame.height)
        }
    }
    
    func getPosition(_ labelText: String) -> CGPoint? {
        for label in subviews as! [UILabel] {
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
