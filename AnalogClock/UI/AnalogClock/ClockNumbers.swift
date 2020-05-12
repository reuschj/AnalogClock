//
//  ClockNumbers.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/16/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI

/**
 Renders clock numbers around the inner edge of the clock
 */
struct ClockNumbers: View {
    
    /// Type of clock, 12-hour, 24-hour or decimal (value of `ClockType` enum)
    var type: ClockType = .twelveHour
    
    /// Color of clock numbers
    var color: Color = .primary
    
    /// Flag for 24-hour clock vs. 12-hour clock or decimal
    private var twentyFourHour: Bool { type == .twentyFourHour }
    
    /// Flag for decimal clock vs. 12- or 24-hour clock
    private var isDecimal: Bool { type == .decimal }
    
    /// Amount of clock numbers to display
    private var steps: Int { type.rawValue }
    
    /// Angle between each clock number
    private var increment: Double { 360 / Double(steps) }
    
    /// Allowable bounds for font scaling
    private let fontRange: ClosedRange<CGFloat> = 14...40
    
    /**
    Calculates a scaled font size that fits with the clock's diameter
    - Parameter clockDiameter: Diameter of the clock, obtained via geometry
    */
    private func calculateFontSize(clockDiameter: CGFloat) -> CGFloat {
        limitToRange((clockDiameter / 22), range: fontRange)
    }
    
    /**
     Calculates an offset that based on the clock's diameter and scaled font size
     - Parameter clockDiameter: Diameter of the clock, obtained via geometry
     - Parameter fontSize: The size of the font, obtained from `calculateFontSize`
     */
    private func calculateOffset(clockDiameter: CGFloat, fontSize: CGFloat) -> CGFloat {
        (clockDiameter / 2 - fontSize) * -1
    }
    
    /// Positions the clock numbers around the inner edge of the clock
    private func positionClockNumbers(clockDiameter: CGFloat) -> some View {
        let fontSize = calculateFontSize(clockDiameter: clockDiameter)
        let offsetAmount = calculateOffset(clockDiameter: clockDiameter, fontSize: fontSize)
        return ZStack {
            ForEach((1...self.steps), id: \.self) {
                ClockNumber(number: $0, fontSize: fontSize, color: self.color)
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
    
    /// The font size to render the number
    var fontSize: CGFloat = 16
    
    /// The color to render the number
    var color: Color = .primary
    
    var body: some View {
        return Text("\(number)")
            .font(.system(size: fontSize))
            .foregroundColor(color)
    }
}
