//
//  Utils.swift
//  Eko_Assignment
//
//  Created by Venugopalan, Vimal on 27/01/20.
//  Copyright © 2020 Venugopalan, Vimal. All rights reserved.
//

import UIKit

class Utils: NSObject {
    
    /// Set Value in UserDefaults
    /// - Parameters:
    ///   - value: value to be saved
    ///   - key: key of the value
    class func save(value: Any?, for key:String){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    /// Get Value in UserDefaults
    /// - Parameter key: key of the value
    class func getValue(for key:String) -> Any? {
        UserDefaults.standard.value(forKey: key)
    }
}
