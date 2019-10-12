//
//  UIViewControllerExtension.swift
//  AnalogClock
//
//  Created by Justin Reusch on 5/28/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import UIKit

// Provides a shortcut to the app delegate and properties stored in the app delegate s
struct App {
    
    // Shortcut to the app delegate
    static var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    // Shortcut to app settings
    static var settings: AppSettings {
        return App.appDelegate.settings
    }
}

// Adds shortcuts to app properties on UIViewController instances
extension UIViewController {
    
    var app: AppDelegate {
        return App.appDelegate
    }
    
    var settings: AppSettings {
        return App.settings
    }
}

// Adds shortcuts to app properties on UIView instances
extension UIView {
    var app: AppDelegate {
        return App.appDelegate
    }
}
