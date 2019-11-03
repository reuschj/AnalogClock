//
//  DateDisplayView.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/20/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI
import TimeKeeper

/**
 A date display view module
 */
struct DateDisplayView: View {
    
    /// Emits the current time and date at regular intervals
    @ObservedObject var timeEmitter: ClockTimeEmitter = getTimeEmitter()
    
    /// The emitted time from the `timeEmitter`
    var time: TimeKeeper { timeEmitter.time }
    
    /// The color of the date display text
    var color: Color = .primary
    
    /// The font to use for the date display text
    var font: Font = .body
    
    var body: some View {
        HStack {
            Spacer()
            TimeTextBlock(text: time.dateString, color: color, font: font)
            Spacer()
        }
    }
}
