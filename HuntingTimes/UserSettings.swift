//
//  UserSettings.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 12/9/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import Foundation

class UserSettings {
    class func setSetting(_ object: AnyObject, forKey: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(object, forKey: forKey)
        userDefaults.synchronize()
    }
    
    class func getSetting(_ key: String) -> AnyObject? {
        return UserDefaults.standard.object(forKey: key) as AnyObject?
    }
    
    class func getBackgroundImage() -> NSString {
        if let bgImage = getSetting("backgroundImage") as? NSString {
            return bgImage
        } else {
            return "dark-forest.jpg"
        }
    }
    
    class func setBackgroundImage(_ imageName: String) {
        setSetting(imageName as AnyObject, forKey: "backgroundImage")
    }
}
