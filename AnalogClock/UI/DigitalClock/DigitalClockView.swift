//
//  DigitalClockView.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/16/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI

struct DigitalClockView: View {
    
    @ObservedObject var timeEmitter: TimeEmitter
    var type: ClockType = ClockType.twelveHour
    
    var time: TimeKeeper { timeEmitter.time }
    
    var body: some View {
        HStack {
            Spacer()
            TimeTextBlock(text: type == .twelveHour ? time.hour12String : time.hour24String)
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
