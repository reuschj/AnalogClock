//
//  AnalogClockView.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/16/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI

/**
 A complete analog clock view module
 */
struct AnalogClockView: View {
    
    /// Keeps track of the 
    var timeEmitter: TimeEmitter = getTimeEmitter()
    
    var type: ClockType = ClockType.twelveHour
    
    var lineWidth: CGFloat = 1
    
    @ObservedObject var settings: AppSettings = getAppSettings()
    
    private let padding: CGFloat = UIMeasurement(2).value
    
    private func getSize(_ geometry: GeometryProxy) -> CGFloat { CGFloat.minimum(geometry.size.width, geometry.size.height) }
    
    private func renderClock(size: CGFloat) -> some View {
        ZStack {
            Circle()
                .foregroundColor(.clear)
                .overlay(Circle()
                    .stroke(Color.secondary, lineWidth: lineWidth))
            ClockNumbers(type: type, color: .primary)
            if settings.analogClockOptions.tickMarks {
                ClockTicks(color: .primary)
            }
            HourHand(timeEmitter: timeEmitter, twentyFourHour: type == .twentyFourHour, color: .accentColor)
            MinuteHand(timeEmitter: timeEmitter, color: .primary)
            SecondHand(timeEmitter: timeEmitter, color: .secondary)
        }
        .frame(width: size, height: size, alignment: .center)
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.renderClock(size: self.getSize(geometry))
        }
    }
}
