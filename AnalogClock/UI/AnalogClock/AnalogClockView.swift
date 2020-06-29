//
//  AnalogClockView.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/16/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI
import StrokedShape
import Percent

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
    
    private var theme: Theme { settings.theme.settings.analog }
    private var colors: Theme.Colors { theme.colors }
    
    private var shape: ClockShape { theme.shape }
    
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
            // Clock outline --------------------- /
            shape.circle.map { circle in
                StrokedShape(
                    foreground: colors.clock.fill ?? .clear,
                    outlineColor: colors.clock.outline,
                    outlineWidth: theme.outlineWidth
                ) { circle }
            }
            shape.square.map { square in
                StrokedShape(
                    foreground: colors.clock.fill ?? .clear,
                    outlineColor: colors.clock.outline,
                    outlineWidth: theme.outlineWidth
                ) { square }
            }
            // Clock numbers --------------------- /
            ClockNumbers(
                type: type,
                clockFont: theme.numbers,
                color: colors.clockNumbers
            )
            // Add tick marks --------------------- /
            if settings.analogClockOptions.tickMarks {
                ClockTicks(
                    color: colors.clockMinorTicks,
                    steps: minorSteps
                )
                ClockTicks(color: colors.clockMajorTicks, steps: majorSteps)
            }
            if settings.analogClockOptions.periodDisplay && type == .twelveHour {
                PeriodDisplayView(
                    dimensions: theme.periodHand,
                    colorTheme: colors,
                    font: theme.periodText
                )
            }
            // Hands --------------------- /
            ClockHand.Hour(
                dimensions: theme.hourHand,
                colorTheme: colors,
                clockType: type
            )
            ClockHand.Minute(
                dimensions: theme.minuteHand,
                colorTheme: colors,
                clockType: type
            )
            ClockHand.Second(
                dimensions: theme.secondHand,
                colorTheme: colors,
                clockType: type
            )
            // Pivot --------------------- /
            ClockHand.Pivot(
                shape: theme.pivotShape,
                scale: theme.pivotScale,
                outlineWidth: theme.pivotOutlineWidth,
                colorTheme: colors
            )
            // Tick Tock --------------------- /
            if settings.analogClockOptions.tickTockDisplay {
                TickTockDisplayView(
                    color: colors.tickTockHand.fill ?? .primary
                )
            }
        }
            .frame(
                width: size.width,
                height: size.height,
                alignment: .center
            )
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.renderClock(size: self.getSize(geometry))
        }
    }
    
    struct Theme {
        var shape: ClockShape = .circle
        var colors: Colors = Colors()
        var outlineWidth: CGFloat = 1
        var numbers: FlexClockFont = FlexClockFont(scale: UIPercent(oneOver: 16, of: .container(.diameter, of: "clock")))
        var hourHand: ClockHand.Dimensions = ClockHand.Hour.defaultDimensions
        var minuteHand: ClockHand.Dimensions = ClockHand.Minute.defaultDimensions
        var secondHand: ClockHand.Dimensions = ClockHand.Second.defaultDimensions
        var periodHand: ClockHand.Dimensions = ClockHand.Period.defaultDimensions
        var periodText: FlexClockFont = FlexClockFont(scale: UIPercent(oneOver: 30, of: .container(.diameter, of: "clock")))
        var pivotScale: UIPercent = UIPercent(oneOver: 25, of: .container(.diameter, of: "clock"))
        var pivotShape: ClockHand.Shape.Pivot = .circle
        var pivotOutlineWidth: CGFloat = 1
        
        struct Colors {
            var clock: ClockElementColor = ClockElementColor(fill: nil, outline: .primary)
            var clockNumbers: Color = .primary
            var clockMajorTicks: Color = .primary
            var clockMinorTicks: Color = .primary
            // Hands
            var hourHand: ClockElementColor = ClockElementColor(fill: .primary)
            var minuteHand: ClockElementColor = ClockElementColor(fill: .primary)
            var secondHand: ClockElementColor = ClockElementColor(fill: .primary)
            // Period hand
            var periodHand: ClockElementColor = ClockElementColor(fill: .primary)
            var periodText: Color? = .secondary
            // Tick tock pendulum
            var tickTockHand: ClockElementColor = ClockElementColor(fill: .secondary)
            // Pivot
            var pivot: ClockElementColor = ClockElementColor(fill: .primary)
        }
    }
}
