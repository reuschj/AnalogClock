//
//  ClockHands.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/16/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI

struct HourHand: View {
        
    var twentyFourHour: Bool = false
    
    var color: Color = .primary
    
    var type: ClockHandType { twentyFourHour ? .twentyFourHour : .hour }
    
    var body: some View {
        ClockHand(lengthRatio: 0.6, width: 6, type: type, color: color)
    }
}

struct MinuteHand: View {
        
    var color: Color = .primary
    
    var body: some View {
        ClockHand(lengthRatio: 0.85, width: 4, type: .minute, color: color)
    }
}

struct SecondHand: View {
    
    var color: Color = .primary
    
    @ObservedObject var timeEmitter: TimeEmitter = getTimeEmitter()
    
    private var type: ClockHandType { timeEmitter.interval < 1 ? .preciseSecond : .second }
    
    var body: some View {
        ClockHand(lengthRatio: 0.92, width: 2, type: type, color: color)
    }
}

struct ClockHand: View {
    
    /// Emits the current time and date at regular intervals
    @ObservedObject var timeEmitter: TimeEmitter = getTimeEmitter()
    
    var lengthRatio: CGFloat = 1
    var width: CGFloat = 4
    var type: ClockHandType = .hour
    var color: Color = .primary
    
    private var rotationInDegrees: Double {
        switch type {
        case.twentyFourHour:
            return timeEmitter.handController.hour24 ?? 0
        case .hour:
            return timeEmitter.handController.hour ?? 0
        case .minute:
            return timeEmitter.handController.minute ?? 0
        case .second:
            return timeEmitter.handController.second ?? 0
        case .preciseSecond:
            return timeEmitter.handController.preciseSecond ?? 0
        case .period:
            return timeEmitter.handController.period ?? 0
        default:
            return 0
        }
    }
    
    var body: some View {
        ClockHandShape(lengthRatio: lengthRatio, width: width)
            .foregroundColor(color)
            .scaledToFit()
            .rotationEffect(Angle(degrees: rotationInDegrees))
    }
}

struct ClockHandShape: View {
    
    private var lengthRatio: CGFloat
    private var width: CGFloat
    private var overhangRatio: CGFloat
    
    private let ratioRange: ClosedRange<CGFloat> = 0...1.0
    
    init(lengthRatio: CGFloat = 1.0, width: CGFloat = 4, overhangRatio: CGFloat = 0.1) {
        self.lengthRatio = limitToRange(lengthRatio, range: ratioRange)
        self.width = width
        self.overhangRatio = limitToRange(overhangRatio, range: ratioRange)
    }
    
    private func getLength(clockDiameter: CGFloat) -> CGFloat {
        let radius = clockDiameter / 2
        return (radius * lengthRatio) + (radius * overhangRatio)
    }
    
    private func getOffset(clockDiameter: CGFloat) -> CGFloat {
        let halfRadius = clockDiameter / 4
        return (halfRadius * lengthRatio) - (halfRadius * overhangRatio)
    }
    
    func renderClockHand(clockDiameter: CGFloat) -> some View {
        let length = getLength(clockDiameter: clockDiameter)
        let offset = getOffset(clockDiameter: clockDiameter)
        return RoundedRectangle(cornerRadius: self.width / 2)
            .frame(width: width, height: length, alignment: .bottom)
            .offset(x: 0, y: offset)
            .rotationEffect(Angle(degrees: 180))
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.renderClockHand(clockDiameter: geometry.size.width)
        }
        
    }
}
