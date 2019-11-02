//
//  DigitalClockView.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/16/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI

struct DigitalClockView: View {
    
    /// Emits the current time and date at regular intervals
    @ObservedObject var timeEmitter: TimeEmitter = getTimeEmitter()
    
    /// Type of clock, 12 or 24-hour
    var type: ClockType = ClockType.twelveHour
    
    /// The emitted time from the `timeEmitter`
    var time: TimeKeeper { timeEmitter.time }
    
    var body: some View {
        HStack {
            Spacer()
            TimeTextBlock(text: type == .twelveHour ? time.hour12String : time.hour24String)
            DigitalClockSeparator()
            TimeTextBlock(text: time.paddedMinute)
            DigitalClockSeparator()
            TimeTextBlock(text: time.paddedSecond)
            if type == .twelveHour {
                DigitalClockSeparator()
                TimeTextBlock(text: time.periodString)
            }
            Spacer()
        }
    }
}
