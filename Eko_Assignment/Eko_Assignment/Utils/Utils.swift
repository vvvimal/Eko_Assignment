//
//  Utils.swift
//  Eko_Assignment
//
//  Created by Venugopalan, Vimal on 27/01/20.
//  Copyright © 2020 Venugopalan, Vimal. All rights reserved.
//

import UIKit

class Utils: NSObject {
    
    class func save(value: Any?, for key:String){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func getValue(for key:String) -> Any? {
        UserDefaults.standard.value(forKey: key)
    }
}
