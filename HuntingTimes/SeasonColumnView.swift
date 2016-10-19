//
//  SeasonColumnView.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 3/10/15.
//  Copyright (c) 2015 Ryan Norman. All rights reserved.
//

import UIKit

class SeasonColumnView : ColumnView {
    override func setLabels(_ labels: [String]) {
        for view in self.subviews as [UIView] {
            view.removeFromSuperview()
        }
        
        var index = 0
        for text in labels {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: 35))
            label.text              = text
            label.textColor         = .white
            label.font              = UIFont(name: "HelveticaNeue-Thin", size: 22)
            label.sizeToFit()
            label.center            = CGPoint(x: label.center.x, y: index == 0 ? label.frame.height / 2 : frame.height - label.frame.height / 2)
            setPositionOfLabel(label)
            addSubview(label)
            index += 1
        }
    }
}
