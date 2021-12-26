//
//  TickTockDisplayView.swift
//  AnalogClock
//
//  Created by Justin Reusch on 12/7/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI

/**
 Displays an animated pendulum that swings left and right every second
 */
struct TickTockDisplayView: View {
    
    /// Color of pendulum
    var color: Color = .primary
    
    /**
     Calculates an offset based on the clock's diameter
     - Parameters:
         - clockDiameter: Diameter of the clock, obtained via geometry
     */
    private func calculateOffset(clockDiameter: CGFloat) -> OffsetAmount {
        (x: 0, y: clockDiameter * 0.55)
    }
    
    /**
     Calculates pendulum size based on the clock's diameter
     - Parameters:
        - clockDiameter: Diameter of the clock, obtained via geometry
     */
    private func calculateSize(clockDiameter: CGFloat) -> ClockSize {
        let size = clockDiameter / 40
        return (height: size, width: size)
    }
    
    /// Positions the clock numbers around the inner edge of the clock
    private func positionTickTockDisplay(clockDiameter: CGFloat) -> some View {
        let offsetAmount = calculateOffset(clockDiameter: clockDiameter)
        let size = calculateSize(clockDiameter: clockDiameter)
        return TickTockDisplay(color: color, size: size, offset: offsetAmount)
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.positionTickTockDisplay(clockDiameter: geometry.size.width)
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.height,
                    alignment: .center
                )
        }
    }
}

/**
 Displays an animated pendulum that swings left and right every second
 */
struct TickTockDisplay: View {
    
    /// Color of pendulum
    var color: Color
    
    /// Size of the tick tock pendulum
    var size: ClockSize
    
    /// Offset of pendulum from center of the clock
    var offset: OffsetAmount
    
    /// Emits the current time and date at regular intervals
    @ObservedObject var timeEmitter: ClockTimeEmitter = getTimeEmitter()
    
    var body: some View {
        Circle()
            .frame(width: size.width, height: size.height, alignment: .center)
            .overlay(Rectangle()
                .frame(width: 2, height: size.height * 2, alignment: .center)
                .offset(x: 0, y: -size.height)
            )
            .foregroundColor(color)
            .offset(x: offset.x, y: offset.y)
            .rotationEffect(Angle(degrees: (timeEmitter.clockHand.tickTockPendulum ?? 0) * ClockHandConstants.Rotation.tickTockDelta) + ClockHandConstants.Rotation.tickTockOffset)
    }
}

struct TickTockDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        TickTockDisplayView(color: .primary)
    }
}
