//
//  ClockHands.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/16/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI

/**
 A clock hand with presets for use as an hour hand
 */
struct HourHand: View {
    
    /// Clock type (12-hour, 24-hour or decimal)
    var clockType: ClockType = .twelveHour
    
    /// Sets the color of the hand
    var color: Color = .primary
    
    /// Computed value that gets the clock hand type (12-hour, 24-hour or decimal)
    private var type: ClockHandType {
        switch clockType {
        case .twelveHour:
            return .hour(base: .twelve)
        case .twentyFourHour:
            return .hour(base: .twentyFour)
        case .decimal:
            return .hour(base: .decimal)
        }
    }
    
    var body: some View {
        ClockHand(lengthRatio: 0.6, width: 6, type: type, color: color)
    }
}

/**
 A clock hand with presets for use as an minute hand
 */
struct MinuteHand: View {
    
    /// Clock type (12-hour, 24-hour or decimal)
    var clockType: ClockType = .twelveHour
        
    /// Sets the color of the hand
    var color: Color = .primary
    
    /// Computed value that gets the clock hand type (12-hour, 24-hour or decimal)
    private var type: ClockHandType {
        switch clockType {
        case .twelveHour, .twentyFourHour:
            return .minute(base: .standard)
        case .decimal:
            return .minute(base: .decimal)
        }
    }
    
    var body: some View {
        ClockHand(lengthRatio: 0.85, width: 4, type: type, color: color)
    }
}

/**
 A clock hand with presets for use as an second hand
 */
struct SecondHand: View {
    
    /// Clock type (12-hour, 24-hour or decimal)
    var clockType: ClockType = .twelveHour
    
    /// Sets the color of the hand
    var color: Color = .primary
    
    /// Emits the current time and date at regular intervals
    @ObservedObject var timeEmitter: ClockTimeEmitter = getTimeEmitter()
    
    /// Global app settings
    @ObservedObject var settings: AppSettings = getAppSettings()
    
    /// Computed value that gets the clock hand type (12-hour, 24-hour or decimal)
    private var type: ClockHandType {
        let isPrecise: Bool = settings.precision > ClockPrecision.low
        switch clockType {
        case .twelveHour, .twentyFourHour:
            return .second(base: .standard, precise: isPrecise)
        case .decimal:
            return .second(base: .decimal, precise: isPrecise)
        }
    }
    
    var body: some View {
        ClockHand(lengthRatio: 0.92, width: 2, type: type, color: color)
    }
}

/**
 A clock hand with presets for use as an period hand
 */
struct PeriodHand: View {
    
    /// Sets the color of the hand
    var color: Color = .secondary
    
    /// Emits the current time and date at regular intervals
    @ObservedObject var timeEmitter: ClockTimeEmitter = getTimeEmitter()

    var body: some View {
        ClockHand(lengthRatio: 0.95, width: 3, type: .period, color: color, overhangRatio: 0.25, notchMultiplier: 3)
    }
}

/**
 A generic updatable clock hand that observes a time emitter
 */
struct ClockHand: View {
    
    /// Emits the current time and date at regular intervals
    @ObservedObject var timeEmitter: ClockTimeEmitter = getTimeEmitter()
    
    var lengthRatio: CGFloat = 1
    var width: CGFloat = 4
    var type: ClockHandType = .hour(base: .twelve)
    var color: Color = .primary
    var overhangRatio: CGFloat = 0.1
    var hasPivotNotch: Bool = true
    var notchMultiplier: CGFloat = 2
    
    private var rotationInDegrees: Double {
        switch type {
        case .hour(let base):
            switch base {
            case .twelve: return timeEmitter.clockHand.hour ?? 0
            case .twentyFour: return timeEmitter.clockHand.hour24 ?? 0
            case .decimal: return timeEmitter.clockHand.hourDecimal ?? 0
            }
        case .minute(let base):
            switch base {
            case .standard: return timeEmitter.clockHand.minute ?? 0
            case .decimal: return timeEmitter.clockHand.minuteDecimal ?? 0
            }
        case .second(let base, let precise):
            switch base {
            case .standard: return precise ? (timeEmitter.clockHand.preciseSecond ?? 0) : (timeEmitter.clockHand.second ?? 0)
            case .decimal: return precise ? (timeEmitter.clockHand.preciseSecondDecimal ?? 0) : (timeEmitter.clockHand.secondDecimal ?? 0)
            }
        case .period:
            return (timeEmitter.clockHand.period ?? 0) * ClockHand.periodRotationDelta
        case .tickTock:
            return (timeEmitter.clockHand.tickTock ?? 0) * ClockHand.tickTockRotationDelta
        case .tickTockPendulum:
            return (timeEmitter.clockHand.tickTockPendulum ?? 0) * ClockHand.tickTockRotationDelta
        }
    }
    
    var body: some View {
        ClockHandShape(lengthRatio: lengthRatio, width: width, overhangRatio: overhangRatio, hasPivotNotch: hasPivotNotch, notchMultiplier: notchMultiplier)
            .foregroundColor(color)
            .scaledToFit()
            .rotationEffect(Angle(degrees: rotationInDegrees))
    }
    
    static let periodRotationDelta: Double = 55
    static var periodRotationOffset: Angle { Angle(degrees:  -periodRotationDelta / 2) }
    
    static let tickTockRotationDelta: Double = 15
    static var tickTockRotationOffset: Angle { Angle(degrees:  -tickTockRotationDelta / 2) }
}

/**
 Used to draw the basic shape of a clock hand
 */
struct ClockHandShape: View {
    
    private var lengthRatio: CGFloat
    private var width: CGFloat
    private var overhangRatio: CGFloat
    private var hasPivotNotch: Bool = true
    private var notchMultiplier: CGFloat = 2
    
    private let ratioRange: ClosedRange<CGFloat> = 0...1.0
    
    init(lengthRatio: CGFloat = 1.0, width: CGFloat = 4, overhangRatio: CGFloat = 0.1, hasPivotNotch: Bool = true, notchMultiplier: CGFloat = 2) {
        self.lengthRatio = limitToRange(lengthRatio, range: ratioRange)
        self.width = width
        self.overhangRatio = limitToRange(overhangRatio, range: ratioRange)
        self.hasPivotNotch = hasPivotNotch
        self.notchMultiplier = notchMultiplier
    }
    
    private func getLength(clockDiameter: CGFloat) -> CGFloat {
        let radius = clockDiameter / 2
        return (radius * lengthRatio) + (radius * overhangRatio)
    }
    
    private func getOffset(clockDiameter: CGFloat) -> CGFloat {
        let halfRadius = clockDiameter / 4
        return (halfRadius * lengthRatio) - (halfRadius * overhangRatio)
    }
    
    private func getPivotNotch(diameter: CGFloat) -> some View {
        Circle()
            .frame(width: diameter, height: diameter, alignment: .center)
            .scaledToFit()
    }
    
    func renderClockHand(clockDiameter: CGFloat) -> some View {
        let length = getLength(clockDiameter: clockDiameter)
        let offset = getOffset(clockDiameter: clockDiameter)
        return RoundedRectangle(cornerRadius: self.width / 2)
            .frame(width: width, height: length, alignment: .bottom)
            .offset(x: 0, y: offset)
            .rotationEffect(Angle(degrees: 180))
            .overlay(ZStack { if hasPivotNotch { getPivotNotch(diameter: width * notchMultiplier) } })
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.renderClockHand(clockDiameter: geometry.size.width)
        }
        
    }
}
