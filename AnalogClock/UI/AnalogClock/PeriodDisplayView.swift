//
//  PeriodDisplayView.swift
//  AnalogClock
//
//  Created by Justin Reusch on 11/15/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI

/**
 Displays the period (AM/PM) on an analog clock with small hand that points to AM or PM
 */
struct PeriodDisplayView: View {
    
    /// Color of period text _and_ hand
    var color: Color = .primary
    
    /// Allowable bounds for font scaling
    private let fontRange: ClosedRange<CGFloat> = 10...30
    
    /**
     Calculates a scaled font size that fits with the clock's diameter
     - Parameters:
        - clockDiameter: Diameter of the clock, obtained via geometry
     */
    private func calculateFontSize(clockDiameter: CGFloat) -> CGFloat {
        limitToRange((clockDiameter / 30), range: fontRange)
    }
    
    /**
     Calculates an offset that based on the clock's diameter and scaled font size
     - Parameters:
         - clockDiameter: Diameter of the clock, obtained via geometry
         - fontSize: The size of the font, obtained from `calculateFontSize`
     */
    private func calculateOffset(clockDiameter: CGFloat, fontSize: CGFloat) -> (x: CGFloat, y: CGFloat) {
        (x: 0, y: clockDiameter / 4)
    }
    
    /// Positions the clock numbers around the inner edge of the clock
    private func positionPeriodDisplay(clockDiameter: CGFloat) -> some View {
        let fontSize = calculateFontSize(clockDiameter: clockDiameter)
        let offsetAmount = calculateOffset(clockDiameter: clockDiameter, fontSize: fontSize)
        return PeriodDisplay(fontSize: fontSize, color: color)
            .offset(x: offsetAmount.x, y: offsetAmount.y)
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
    
    /// Size of the AM/PM font
    var fontSize: CGFloat
    
    /// Color of period text _and_ hand
    var color: Color
    
    /// Emits the current time and date at regular intervals
    @ObservedObject var timeEmitter: ClockTimeEmitter = getTimeEmitter()
    
    /// Calculates hand size based on font size
    var handFrameSize: ClockSize {
        (height: fontSize * 4, width: fontSize * 4)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(timeEmitter.time.calendar.amSymbol)
                    .font(.system(size: fontSize))
                    .foregroundColor(color)
                Text(timeEmitter.time.calendar.pmSymbol)
                    .font(.system(size: fontSize))
                    .foregroundColor(color)
            }
            PeriodHand(color: color)
                .rotationEffect(ClockHand.periodRotationOffset)
                .frame(width: handFrameSize.width, height: handFrameSize.height, alignment: .center)
                .offset(x: 0, y: -handFrameSize.height / 4)
        }
    }
}

struct PeriodDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            PeriodDisplayView(color: .gray)
                .frame(width: geometry.size.width, height: geometry.size.width, alignment: .center)
        }
        
    }
}
