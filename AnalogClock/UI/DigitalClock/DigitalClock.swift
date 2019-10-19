//
//  DigitalClock.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/16/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI

struct DigitalClock: View {
    
    @ObservedObject var timeEmitter: TimeEmitter
    var type: ClockType = ClockType.twelveHour
    
    var time: TimeKeeper { timeEmitter.time }
    
    var body: some View {
        HStack {
            Spacer()
            TimeTextBlock(text: time.hour12String)
            DigitalClockSeperator()
            TimeTextBlock(text: time.paddedMinute)
            DigitalClockSeperator()
            TimeTextBlock(text: time.paddedSecond)
            DigitalClockSeperator()
            TimeTextBlock(text: time.period?.rawValue)
            Spacer()
        }
    }
}