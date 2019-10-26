//
//  ClockTicks.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/26/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI

/**
 Renders clock numbers around the inner edge of the clock
 */
struct ClockTicks: View {
    
    /// Color of clock ticks
    var color: Color = .primary
    
    /// Amount of clock ticks to display
    private let steps: Int = 24
    /// Angle between each clock tick
    private let increment: Double  = 15
    
    /// Allowable bounds for tick scaling
    private let tickSizeRange: ClosedRange<CGFloat> = 2...10
    
    /// Calculates a scaled tick size that fits with the clock's diameter
    private func calculateTickSize(clockDiameter: CGFloat) -> CGFloat {
        limitToRange((clockDiameter / 60), range: tickSizeRange)
    }
    
    /// Calculates an offset that based on the clock's diameter and scaled tick size
    private func calculateOffset(clockDiameter: CGFloat, tickSize: CGFloat) -> CGFloat {
        (clockDiameter / 2) * -1
    }
    
    /// Positions the clock ticks around the inner edge of the clock
    private func positionClockTicks(clockDiameter: CGFloat) -> some View {
        let tickSize = calculateTickSize(clockDiameter: clockDiameter)
        let offsetAmount = calculateOffset(clockDiameter: clockDiameter, tickSize: tickSize)
        return ZStack {
            ForEach((1...self.steps), id: \.self) {
                ClockTickMark(tickSize: tickSize, color: self.color)
//                    .rotationEffect(Angle(degrees: self.increment * -Double($0)))
                    .offset(x: 0, y: offsetAmount)
                    .rotationEffect(Angle(degrees: self.increment * Double($0)))
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.positionClockTicks(clockDiameter: geometry.size.width)
        }
    }
}

/**
 Renders an individual clock tick
 */
struct ClockTickMark: View {
    
    /// The font size to render the number
    var tickSize: CGFloat = 8
    
    /// The color to render the number
    var color: Color = .primary
    
    private func getOrigin(from geometry: GeometryProxy) -> CGPoint {
        let size = min(geometry.size.width, geometry.size.height)
        return CGPoint(x: size / 2, y: size / 2)
    }
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let origin = self.getOrigin(from: geometry)
                path.move(to: origin)
                path.addLine(to: CGPoint(x: origin.x, y: origin.y + self.tickSize))
            }.stroke(self.color)
        }
    }
}
