//
//  SeasonColumnView.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 3/10/15.
//  Copyright (c) 2015 Ryan Norman. All rights reserved.
//

import UIKit

class SeasonColumnView : ColumnView {
    override func setLabels(labels: [String]) {
        for view in self.subviews as [UIView] {
            view.removeFromSuperview()
        }
        
        for (index, text) in enumerate(labels) {
            let label = UILabel(frame: CGRectMake(0, 0, frame.width, 35))
            label.text              = text
            label.textColor         = .whiteColor()
            label.font              = UIFont(name: "HelveticaNeue-Thin", size: 22)
            label.sizeToFit()
            label.center            = CGPointMake(label.center.x, index == 0 ? label.frame.height / 2 : frame.height - label.frame.height / 2)
            setPositionOfLabel(label)
            addSubview(label)
        }
    }
}
