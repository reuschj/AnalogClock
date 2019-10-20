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
            if type == .twelveHour {
                DigitalClockSeperator()
                TimeTextBlock(text: time.period?.rawValue)
            }
            Spacer()
        }
    }
}

struct DateDisplay: View {
    
    @ObservedObject var timeEmitter: TimeEmitter
    
    var time: TimeKeeper { timeEmitter.time }
    
    var font: Font = .body
    
    var body: some View {
        HStack {
            Spacer()
            TimeTextBlock(text: time.dayOfWeek, font: font)
            TimeTextBlock(text: ",", font: font)
            TimeTextBlock(text: time.monthName, font: font)
            TimeNumberBlock(number: time.day, font: font)
            TimeTextBlock(text: ",", font: font)
            TimeNumberBlock(number: time.year, font: font)
            Spacer()
        }
    }
}
