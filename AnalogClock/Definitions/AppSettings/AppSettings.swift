//
//  AppSettings.swift
//  AnalogClock
//
//  Created by Justin Reusch on 5/28/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import Foundation

// Class to hold app state object for app settings
class AppSettings {
    
    // Static variables for global settings
    static var clockType: ClockType = .twelveHour
    static var hasAnalogClock: Bool = true
    static var hasDigitalClock: Bool = true
    static var hasDateDisplay: Bool = true
    
    // Instance variables for local settings or creating instances on the app delegate
    var clockType: ClockType = .twelveHour
    var hasAnalogClock: Bool = true
    var hasDigitalClock: Bool = true
    var hasDateDisplay: Bool = true
    
    // Initializer
    init(
        clockType: ClockType = .twelveHour,
        hasAnalogClock: Bool = true,
        hasDigitalClock: Bool = true,
        hasDateDisplay: Bool = true
    ) {
        self.clockType = clockType
        self.hasAnalogClock = hasAnalogClock
        self.hasDigitalClock = hasDigitalClock
        self.hasDateDisplay = hasDateDisplay
    }
}
