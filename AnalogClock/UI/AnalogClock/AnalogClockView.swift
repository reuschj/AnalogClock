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
    
    /// Emits the current time and date at regular intervals
    var timeEmitter: ClockTimeEmitter = getTimeEmitter()
    
    /// Type of clock, 12-hour, 24-hour or decimal
    var type: ClockType = .twelveHour
    
    /// Width of clock's outer outline
    var lineWidth: CGFloat = 2
    
    /// Global app settings
    @ObservedObject var settings: AppSettings = getAppSettings()
    
    /// Amount of major (hour) tick marks to show
    private var majorSteps: Int { type == .decimal ? 10 : 12 }
    
    /// Amount of minor (minute/second) tick marks to show
    private var minorSteps: Int { type == .decimal ? 100 : 60 }
    
    /**
     Gets the size of the clock by reading the parent geometry
    - Parameters:
        - geometry: Geometry from a `GeometryReader`
     */
    private func getSize(_ geometry: GeometryProxy) -> CGFloat { min(geometry.size.width, geometry.size.height) }
    
    /**
     Renders the clock at the specified size
     - Parameters:
        - size: The diameter of the clock
     */
    private func renderClock(size: CGFloat) -> some View {
        ZStack {
            Circle()
                .foregroundColor(.clear)
                .overlay(Circle()
                    .stroke(Color.secondary, lineWidth: lineWidth))
            ClockNumbers(type: type, color: .primary)
            // Add tick marks
            if settings.analogClockOptions.tickMarks {
                ClockTicks(color: .gray, steps: minorSteps)
                ClockTicks(color: .secondary, steps: majorSteps)
            }
            // Add hands
            HourHand(clockType: type, color: .accentColor)
            MinuteHand(clockType: type, color: .primary)
            SecondHand(clockType: type, color: .secondary)
            if settings.analogClockOptions.periodDisplay && type == .twelveHour {
                PeriodDisplayView(color: .gray)
            }
        }
        .frame(width: size, height: size, alignment: .center)
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.renderClock(size: self.getSize(geometry))
        }
    }
}
