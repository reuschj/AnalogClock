//
//  AppSettings.swift
//  AnalogClock
//
//  Created by Justin Reusch on 5/28/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI

/**
 Class to hold app state object for app settings
 */
class AppSettings: ObservableObject {
    
    @Published var clockType: ClockType = .twelveHour {
        didSet { UserDefaults.standard.set(clockType == .twelveHour, forKey: defaultsKeys.twelveHourClock) }
    }
    @Published var precision: ClockPrecision = .low {
        didSet {
            UserDefaults.standard.set(precision.rawValue, forKey: defaultsKeys.timeInterval)
            actualPrecision = precision == .low && analogClockOptions.tickTockDisplay ? .medium : precision
            
        }
    }
    @Published var visibleModules: VisibleModules
    @Published var analogClockOptions: AnalogClockOptions
        
    /// Gets the actual precision needed (may be higher than requested precision if tick-tock display is on).
    @Published private(set) var actualPrecision: ClockPrecision = .low
    
    /**
    - Parameters:
        - clockType: Choose between a 12-hour or 24-hour clock
        - precision: Precision at which the clock updates
        - showAnalogClock: Flag for analog clock module visibility
        - showDigitalClock: Flag for digital clock module visibility
        - showDateDisplay: Flag for date display module visibility
        - showTickMarks: Flag for tick mark visibility on the analog clock
        - showPeriodDisplay: Flag for AM/PM period display visibility on the analog clock
        - showTickTockDisplay: Flag for tick tock pendulum visibility on the analog clock
     */
    init(
        clockType: ClockType = .twelveHour,
        precision: ClockPrecision = .low,
        showAnalogClock: Bool = true,
        showDigitalClock: Bool = true,
        showDateDisplay: Bool = true,
        showTickMarks: Bool = true,
        showPeriodDisplay: Bool = false,
        showTickTockDisplay: Bool = false
    ) {
        self.actualPrecision = .low
        self.clockType = clockType
        self.visibleModules = VisibleModules(
            analogClock: showAnalogClock,
            digitalClock: showDigitalClock,
            dateDisplay: showDateDisplay
        )
        self.analogClockOptions = AnalogClockOptions(
            tickMarks: showTickMarks,
            periodDisplay: showPeriodDisplay,
            tickTockDisplay: showTickTockDisplay
        )
        self.precision = precision
    }
    
    /**
     Get user defaults and create new instance
     */
    static func getFromDefaults() -> AppSettings {
        
        let defaults = UserDefaults.standard
        
        // Sets defaults on first run
        let clockDefaultsAreSet = defaults.bool(forKey: defaultsKeys.clockDefaultsAreSet)
        if !clockDefaultsAreSet {
            defaults.set(true, forKey: defaultsKeys.clockDefaultsAreSet)
            defaults.set(true, forKey: defaultsKeys.twelveHourClock)
            defaults.set(1.0, forKey: defaultsKeys.timeInterval)
            defaults.set(true, forKey: defaultsKeys.showAnalogClock)
            defaults.set(true, forKey: defaultsKeys.showDigitalClock)
            defaults.set(true, forKey: defaultsKeys.showDateDisplay)
            defaults.set(true, forKey: defaultsKeys.showTickMarks)
            defaults.set(false, forKey: defaultsKeys.showPeriodDisplay)
            defaults.set(false, forKey: defaultsKeys.showTickTockDisplay)
        }
        
        let twelveHourClock = defaults.bool(forKey: defaultsKeys.twelveHourClock)
        let timeInterval = defaults.double(forKey: defaultsKeys.timeInterval)
        
        return AppSettings(
            clockType: twelveHourClock ? .twelveHour : .twentyFourHour,
            precision: ClockPrecision.getPrecision(from: timeInterval) ?? .low,
            showAnalogClock: defaults.bool(forKey: defaultsKeys.showAnalogClock),
            showDigitalClock: defaults.bool(forKey: defaultsKeys.showDigitalClock),
            showDateDisplay: defaults.bool(forKey: defaultsKeys.showDateDisplay),
            showTickMarks: defaults.bool(forKey: defaultsKeys.showTickMarks),
            showPeriodDisplay: defaults.bool(forKey: defaultsKeys.showPeriodDisplay),
            showTickTockDisplay: defaults.bool(forKey: defaultsKeys.showTickTockDisplay)
        )
    }
}

/**
 Structure containing clock modules thats visibility can be toggled.
 */
struct VisibleModules {
    var analogClock: Bool = true {
        didSet { UserDefaults.standard.set(analogClock, forKey: defaultsKeys.showAnalogClock) }
    }
    var digitalClock: Bool = true {
        didSet { UserDefaults.standard.set(digitalClock, forKey: defaultsKeys.showDigitalClock) }
    }
    var dateDisplay: Bool = true {
        didSet { UserDefaults.standard.set(dateDisplay, forKey: defaultsKeys.showDateDisplay) }
    }
}

/**
 Structure containing analog clock options
 */
struct AnalogClockOptions {
    var tickMarks: Bool = false {
        didSet { UserDefaults.standard.set(tickMarks, forKey: defaultsKeys.showTickMarks) }
    }
    var periodDisplay: Bool = false {
        didSet { UserDefaults.standard.set(periodDisplay, forKey: defaultsKeys.showPeriodDisplay) }
    }
    var tickTockDisplay: Bool = false {
        didSet { UserDefaults.standard.set(tickTockDisplay, forKey: defaultsKeys.showTickTockDisplay) }
    }
    
}
