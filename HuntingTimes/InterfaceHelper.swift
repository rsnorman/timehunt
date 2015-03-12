//
//  InterfaceHelper.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/27/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

func createLabel(text: String, frame: CGRect, fontSize: CGFloat) -> UILabel {
    let label = UILabel(frame: frame)
    label.text = text
    label.textColor = .whiteColor()
    label.font = UIFont(name: "HelveticaNeue-Thin", size: fontSize)
    label.textAlignment = .Center
    
    return label
}

func createPageViewRect(x: CGFloat, width: CGFloat, topPadding: CGFloat = 0) -> CGRect {
    let bottomPadding: CGFloat = 30.0
    let topPosition: CGFloat = 225.0
    
    return CGRectMake(x, topPosition - topPadding, width, UIScreen.mainScreen().bounds.height - (topPosition + bottomPadding - topPadding))
}
