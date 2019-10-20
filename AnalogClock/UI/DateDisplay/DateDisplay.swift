//
//  DateDisplay.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/20/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI

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
