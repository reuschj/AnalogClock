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
    
    /// Global app settings
    @ObservedObject var settings: AppSettings = getAppSettings()
    
    private var theme: AnalogClockTheme { settings.theme.analog }
    private var colors: AnalogClockColorTheme { theme.colors }
    
    /// Amount of major (hour) tick marks to show
    private var majorSteps: Int { type == .decimal ? 10 : 12 }
    
    /// Amount of minor (minute/second) tick marks to show
    private var minorSteps: Int { type == .decimal ? 100 : 60 }
    
    /**
     Gets the size of the clock by reading the parent geometry
    - Parameter geometry: Geometry from a `GeometryReader`
     */
    private func getSize(_ geometry: GeometryProxy) -> ClockSize {
        let size = min(geometry.size.width, geometry.size.height)
        return (height: size, width: size)
    }
    
    /**
     Renders the clock at the specified size
     - Parameter size: The diameter of the clock
     */
    private func renderClock(size: ClockSize) -> some View {
        ZStack {
            Circle()
                .foregroundColor(colors.clockBackground ?? .clear)
                .overlay(colors.clockOutline.map {
                    Circle().stroke($0, lineWidth: theme.clockOutlineWidth)
                })
            ClockNumbers(type: type, color: colors.clockNumbers)
            // Add tick marks
            if settings.analogClockOptions.tickMarks {
                ClockTicks(color: colors.clockMinorTicks, steps: minorSteps)
                ClockTicks(color: colors.clockMajorTicks, steps: majorSteps)
            }
            if settings.analogClockOptions.periodDisplay && type == .twelveHour {
                PeriodDisplayView(color: colors.periodHand, fontColor: colors.periodText)
            }
            // Add hands
            HourHand(clockType: type, color: colors.hourHand)
            MinuteHand(clockType: type, color: colors.minuteHand)
            SecondHand(clockType: type, color: colors.secondHand)
            if settings.analogClockOptions.tickTockDisplay {
                TickTockDisplayView(color: colors.pendulum)
            }
        }
        .frame(width: size.width, height: size.height, alignment: .center)
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.renderClock(size: self.getSize(geometry))
        }
    }
}
