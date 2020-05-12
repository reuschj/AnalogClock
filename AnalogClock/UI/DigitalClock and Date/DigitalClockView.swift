//
//  DigitalClockView.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/16/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI
import TimeKeeper

struct DigitalClockView: View {
    
    /// Emits the current time and date at regular intervals
    @ObservedObject var timeEmitter: ClockTimeEmitter = getTimeEmitter()
    
    /// Type of clock, 12-hour, 24-hour or decimal
    var type: ClockType = .twelveHour
    
    /// The emitted time from the `timeEmitter`
    var time: TimeKeeper { timeEmitter.time }
    
    /// Gets the time text for the hours place
    private var hourTimeText: String? {
        switch type {
        case .twelveHour:
            return time.hour12String
        case .twentyFourHour:
            return time.hour24String
        case .decimal:
            return time.hourDecimalString
        }
    }
    
    /// Gets the time text for the minutes place
    private var minuteTimeText: String? {
        switch type {
        case .twelveHour, .twentyFourHour:
            return time.paddedMinute
        case .decimal:
            return time.paddedDecimalMinute
        }
    }
    
    /// Gets the time text for the seconds place
    private var secondTimeText: String? {
        switch type {
        case .twelveHour, .twentyFourHour:
            return time.paddedSecond
        case .decimal:
            return time.paddedDecimalSecond
        }
    }
    
    var body: some View {
        HStack {
            Spacer()
            TimeTextBlock(text: hourTimeText)
            DigitalClockSeparator()
            TimeTextBlock(text: minuteTimeText)
            DigitalClockSeparator()
            TimeTextBlock(text: secondTimeText)
            if type == .twelveHour {
                DigitalClockSeparator()
                TimeTextBlock(text: time.periodString)
            }
            Spacer()
        }
    }
}
