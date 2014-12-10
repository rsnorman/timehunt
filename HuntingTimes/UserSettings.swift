//
//  UserSettings.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 12/9/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import Foundation

class UserSettings {
    class func setSetting(object: AnyObject, forKey: String) {
        var userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(object, forKey: forKey)
        userDefaults.synchronize()
    }
    
    class func getSetting(key: String) -> AnyObject? {
        return NSUserDefaults.standardUserDefaults().objectForKey(key)
    }
    
    class func getBackgroundImage() -> NSString {
        if let bgImage = getSetting("backgroundImage") as? NSString {
            return bgImage
        } else {
            return "dark-forest.jpg"
        }
    }
    
    class func setBackgroundImage(imageName: String) {
        setSetting(imageName, forKey: "backgroundImage")
    }
}
