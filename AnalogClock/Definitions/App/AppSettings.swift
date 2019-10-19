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
    
    @Published var clockType: ClockType = .twelveHour
    @Published var precision: ClockPrecision = .low
    @Published var visibleModules: VisibleModules
    @Published var analogClockOptions: AnalogClockOptions
        
    /// Gets the acutal precision needed (may be higher than requested precision if tick-tock display is on).
    var actualPrecision: ClockPrecision {
        precision == .low && analogClockOptions.tickTockDisplay ? .medium : precision
    }
    
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
        showTickMarks: Bool = false,
        showPeriodDisplay: Bool = false,
        showTickTockDisplay: Bool = false
    ) {
        self.clockType = clockType
        self.precision = precision
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
    }
}

/**
 Structure containing clock modules thats visibliity can be toggled.
 */
struct VisibleModules {
    var analogClock: Bool = true
    var digitalClock: Bool = true
    var dateDisplay: Bool = true
}

/**
 Structure containing analog clock options
 */
struct AnalogClockOptions {
    var tickMarks: Bool = false
    var periodDisplay: Bool = false
    var tickTockDisplay: Bool = false
    
}