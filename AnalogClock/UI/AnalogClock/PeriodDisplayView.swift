//
//  PeriodDisplayView.swift
//  AnalogClock
//
//  Created by Justin Reusch on 11/15/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI
import StrokedShape
import Percent

/**
 Displays the period (AM/PM) on an analog clock with small hand that points to AM or PM
 */
struct PeriodDisplayView: View {
    
    /// Sets hand dimensions
    var dimensions: ClockHand.Dimensions = ClockHand.Period.defaultDimensions
    
    /// Sets the color theme
    var colorTheme: AnalogClockView.Theme.Colors = AnalogClockView.Theme.Colors()
    
    var font: FlexClockFont = FlexClockFont(scale: UIPercent(oneOver: 30, of: .container(.diameter, of: "clock")))
    
    /// Allowable bounds for font scaling
    private let fontRange: ClosedRange<CGFloat> = 10...30
    
    /**
     Gets font from the clock's diameter
     - Parameter clockDiameter: Diameter of the clock, obtained via geometry
     */
    private func getFont(within clockDiameter: CGFloat) -> Font {
        font.getFont(within: clockDiameter, limitedTo: fontRange)
    }
    
    /**
     Calculates an offset that based on the clock's diameter and scaled font size
     - Parameter clockDiameter: Diameter of the clock, obtained via geometry
     */
    private func calculateOffset(within clockDiameter: CGFloat) -> (x: CGFloat, y: CGFloat) {
        (x: 0, y: clockDiameter / 4)
    }
    
    /// Positions the clock numbers around the inner edge of the clock
    private func positionPeriodDisplay(clockDiameter: CGFloat) -> some View {
        let fontSize = font.getFontSize(within: clockDiameter, limitedTo: fontRange)
        let font = getFont(within: clockDiameter)
        let offsetAmount = calculateOffset(within: clockDiameter)
        return PeriodDisplay(
            dimensions: dimensions,
            font: font,
            fontSize: fontSize,
            colorTheme: colorTheme
        )
            .offset(
                x: offsetAmount.x,
                y: offsetAmount.y
        )
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.positionPeriodDisplay(clockDiameter: geometry.size.width)
        }
    }
}

/**
 Small hand that points to the period (AM/PM) on an analog clock
 */
struct PeriodDisplay: View {
    
    /// Sets hand dimensions
    var dimensions: ClockHand.Dimensions = ClockHand.Period.defaultDimensions
    
    /// Font for the AM/PM font
    var font: Font
    
    var fontSize: CGFloat
    
    /// Sets the color theme
    var colorTheme: AnalogClockView.Theme.Colors = AnalogClockView.Theme.Colors()
    
    /// Emits the current time and date at regular intervals
    @ObservedObject var timeEmitter: ClockTimeEmitter = getTimeEmitter()
    
    /// Color of period hand
    var color: Color? { colorTheme.periodHand.fill }
    
    /// Color of period hand outline
    var outlineColor: Color? { colorTheme.periodHand.outline }
    
    /// Color of period text
    var fontColor: Color? { colorTheme.periodText }
    
    private var actualFontColor: Color { fontColor ?? color ?? outlineColor ?? .gray }
    
    /// Calculates hand size based on font size
    private var handFrameSize: ClockSize {
        let multiplier: CGFloat = 4
        return (
            height: fontSize * multiplier,
            width: fontSize * multiplier
        )
    }
    
    private var pivotDiameter: CGFloat { fontSize * 0.75 }
    
    var body: some View {
        VStack {
            HStack {
                Text(timeEmitter.time.calendar.amSymbol)
                    .font(font)
                    .foregroundColor(actualFontColor)
                Text(timeEmitter.time.calendar.pmSymbol)
                    .font(font)
                    .foregroundColor(actualFontColor)
            }
            ClockHand.Period(
                dimensions: dimensions,
                colorTheme: colorTheme,
                timeEmitter: timeEmitter
            )
                .overlay(
                    StrokedShape(
                        foreground: colorTheme.periodHand.fill,
                        outlineColor: colorTheme.periodHand.outline,
                        outlineWidth: dimensions.outlineWidth
                    ) { Circle() }
                        .frame(
                            width: pivotDiameter,
                            height: pivotDiameter,
                            alignment: .bottom
                        )
                )
                .rotationEffect(ClockHandConstants.Rotation.periodOffset)
                .frame(
                    width: handFrameSize.width,
                    height: handFrameSize.height,
                    alignment: .center
                )
                .offset(x: 0, y: -handFrameSize.height / 4)
        }
    }
}

struct PeriodDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            PeriodDisplayView()
                .frame(width: geometry.size.width, height: geometry.size.width, alignment: .center)
        }
        
    }
}
