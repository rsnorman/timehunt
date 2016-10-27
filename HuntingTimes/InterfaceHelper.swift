//
//  InterfaceHelper.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/27/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

func createLabel(_ text: String, frame: CGRect, fontSize: CGFloat) -> UILabel {
    let label = UILabel(frame: frame)
    label.text = text
    label.textColor = .white
    label.font = UIFont(name: "HelveticaNeue-Thin", size: fontSize)
    label.textAlignment = .center
    
    return label
}

func createPageViewRect(_ x: CGFloat, width: CGFloat, topPadding: CGFloat = 0) -> CGRect {
    let bottomPadding: CGFloat = 30.0
    let topPosition: CGFloat = 225.0
    
    return CGRect(x: x, y: topPosition - topPadding, width: width, height: UIScreen.main.bounds.height - (topPosition + bottomPadding - topPadding))
}
