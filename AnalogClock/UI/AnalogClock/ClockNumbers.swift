//
//  ClockNumbers.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/16/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI
import Percent

/**
 Renders clock numbers around the inner edge of the clock
 */
struct ClockNumbers: View {
    
    /// Type of clock, 12-hour, 24-hour or decimal (value of `ClockType` enum)
    var type: ClockType = .twelveHour
    
    /// Multiplier for font size (compared to clock diameter)
    var clockFont: FlexClockFont = FlexClockFont(scale: UIPercent(oneOver: 16, of: .container(.diameter, of: "clock")))
    
    /// Color of clock numbers
    var color: Color = .primary
    
    /// Amount of clock numbers to display
    private var steps: Int { type.rawValue }
    
    /// Angle between each clock number
    private var increment: Double { 360 / Double(steps) }
    
    /// Allowable bounds for font scaling
    private var fontRange: ClosedRange<CGFloat> {
        switch type {
        case .twentyFourHour:
            return 14...19
        default:
            return 14...40
        }
    }
    
    /**
    Calculates a scaled font size that fits with the clock's diameter
    - Parameter clockDiameter: Diameter of the clock, obtained via geometry
    */
    private func getFont(within clockDiameter: CGFloat) -> Font {
        clockFont.getFont(within: clockDiameter, limitedTo: fontRange)
    }
    
    /**
     Calculates an offset that based on the clock's diameter and scaled font size
     - Parameter clockDiameter: Diameter of the clock, obtained via geometry
     */
    private func calculateOffset(within clockDiameter: CGFloat) -> CGFloat {
        let fontSize = clockFont.getFontSize(within: clockDiameter, limitedTo: fontRange)
        return (clockDiameter / 2 - fontSize) * -1
    }
    
    /**
      Converts decimal clock 10 to a zero or passes through original
     - Parameter input: The original input
     */
    private func getNumber(_ input: Int) -> Int { type == .decimal && input == 10 ? 0 : input }
    
    /// Positions the clock numbers around the inner edge of the clock
    private func positionClockNumbers(clockDiameter: CGFloat) -> some View {
        let clockNumberFont = getFont(within: clockDiameter)
        let offsetAmount = calculateOffset(within: clockDiameter)
        return ZStack {
            ForEach((1...self.steps), id: \.self) {
                ClockNumber(number: self.getNumber($0), font: clockNumberFont, color: self.color)
                    .rotationEffect(Angle(degrees: self.increment * -Double($0)))
                    .offset(x: 0, y: offsetAmount)
                    .rotationEffect(Angle(degrees: self.increment * Double($0)))
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.positionClockNumbers(clockDiameter: geometry.size.width)
        }
    }
}

/**
 Renders an individual clock number
 */
struct ClockNumber: View {
    
    /// The number to render
    var number: Int
    
    var font: Font = .system(size: 16)
    
    /// The color to render the number
    var color: Color = .primary
    
    var body: some View {
        return Text("\(number)")
            .font(font)
            .foregroundColor(color)
    }
}
