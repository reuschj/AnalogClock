//
//  ClockHands.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/16/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI

/**
 A generic updatable clock hand that observes a time emitter
 */
struct ClockHand: View {
    
    /// Emits the current time and date at regular intervals
    @ObservedObject var timeEmitter: ClockTimeEmitter = getTimeEmitter()
    
    var shape: Shape
    var lengthRatio: CGFloat = 1
    var width: CGFloat = 4
    var type: ClockHandType = .hour(base: .twelve)
    var color: Color = .primary
    var outlineColor: Color? = nil
    var outlineWidth: CGFloat = 0.5
    var overhangRatio: CGFloat = 0.1
    
    init(
        _ shape: Shape,
        lengthRatio: CGFloat = 1,
        width: CGFloat = 4,
        type: ClockHandType = .hour(base: .twelve),
        color: Color = .primary,
        outlineColor: Color? = nil,
        outlineWidth: CGFloat = 0.5,
        overhangRatio: CGFloat = 0.1
    ) {
        self.shape = shape
        self.lengthRatio = lengthRatio
        self.width = width
        self.type = type
        self.color = color
        self.outlineColor = outlineColor
        self.outlineWidth = outlineWidth
        self.overhangRatio = overhangRatio
    }
    
    init(
        _ clockHand: Dimensions,
        colorTheme: AnalogClockView.Theme.Colors = AnalogClockView.Theme.Colors(),
        type: ClockHandType = .hour(base: .twelve)
    ) {
        var handColor: ClockElementColor
        switch type {
        case .hour(base: _):
            handColor = colorTheme.hourHand
        case .minute(base: _):
            handColor = colorTheme.minuteHand
        case .second(base: _, precise: _):
            handColor = colorTheme.secondHand
        case .period:
            handColor = colorTheme.periodHand
        case .tickTock, .tickTockPendulum:
            handColor = colorTheme.tickTockHand
        }
        self.init(clockHand.shape, lengthRatio: clockHand.lengthRatio, width: clockHand.width, type: type, color: handColor.fill ?? .clear, outlineColor: handColor.outline, outlineWidth: clockHand.outlineWidth, overhangRatio: clockHand.overhangRatio)
    }
    
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
            return (timeEmitter.clockHand.period ?? 0) * ClockHandConstants.Rotation.periodDelta
        case .tickTock:
            return (timeEmitter.clockHand.tickTock ?? 0) * ClockHandConstants.Rotation.tickTockDelta
        case .tickTockPendulum:
            return (timeEmitter.clockHand.tickTockPendulum ?? 0) * ClockHandConstants.Rotation.tickTockDelta
        }
    }
    
    var body: some View {
        Positioner(shape: shape, lengthRatio: lengthRatio, width: width, overhangRatio: overhangRatio, color: color, outlineColor: outlineColor, outlineWidth: outlineWidth)
            .scaledToFit()
            .rotationEffect(Angle(degrees: rotationInDegrees))
    }
    
    struct Dimensions {
        var shape: Shape
        var lengthRatio: CGFloat = 1
        var width: CGFloat = 4
        var outlineWidth: CGFloat = 0.5
        var overhangRatio: CGFloat = 0.1
    }
    
    /**
     A clock hand with presets for use as an hour hand
     */
    struct Hour: View {

        /// Sets hand dimensions
        var dimensions: Dimensions = Hour.defaultDimensions
        
        /// Sets the color theme
        var colorTheme: AnalogClockView.Theme.Colors = AnalogClockView.Theme.Colors()
        
        /// Clock type (12-hour, 24-hour or decimal)
        var clockType: ClockType = .twelveHour
        
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
            ClockHand(dimensions, colorTheme: colorTheme, type: type)
        }
        
        static var defaultDimensions: Dimensions { Dimensions(shape: .roundedRectangle(cornerRadius: 6), lengthRatio: 0.6, width: 6, outlineWidth: ClockHandConstants.Defaults.outlineWidth, overhangRatio: ClockHandConstants.Defaults.overhangRatio) }
    }
    
    /**
     A clock hand with presets for use as an minute hand
     */
    struct Minute: View {
        
        /// Sets hand dimensions
        var dimensions: Dimensions = Minute.defaultDimensions
        
        /// Sets the color theme
        var colorTheme: AnalogClockView.Theme.Colors = AnalogClockView.Theme.Colors()
        
        /// Clock type (12-hour, 24-hour or decimal)
        var clockType: ClockType = .twelveHour
        
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
            ClockHand(dimensions, colorTheme: colorTheme, type: type)
        }
        
        static var defaultDimensions: Dimensions { Dimensions(shape: .roundedRectangle(cornerRadius: 4), lengthRatio: 0.85, width: 4, outlineWidth: ClockHandConstants.Defaults.outlineWidth, overhangRatio: ClockHandConstants.Defaults.overhangRatio) }
    }
    
    /**
     A clock hand with presets for use as an second hand
     */
    struct Second: View {
        
        /// Sets hand dimensions
        var dimensions: Dimensions = Second.defaultDimensions
        
        /// Sets the color theme
        var colorTheme: AnalogClockView.Theme.Colors = AnalogClockView.Theme.Colors()
        
        /// Clock type (12-hour, 24-hour or decimal)
        var clockType: ClockType = .twelveHour
        
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
            ClockHand(dimensions, colorTheme: colorTheme, type: type)
        }
        
        static var defaultDimensions: Dimensions { Dimensions(shape: .roundedRectangle(cornerRadius: 4), lengthRatio: 0.92, width: 3, outlineWidth: ClockHandConstants.Defaults.outlineWidth, overhangRatio: ClockHandConstants.Defaults.overhangRatio) }
    }
    
    /**
     A clock hand with presets for use as an period hand
     */
    struct Period: View {
        
        /// Sets hand dimensions
        var dimensions: Dimensions = Period.defaultDimensions
        
        /// Sets the color theme
        var colorTheme: AnalogClockView.Theme.Colors = AnalogClockView.Theme.Colors()
        
        /// Emits the current time and date at regular intervals
        @ObservedObject var timeEmitter: ClockTimeEmitter = getTimeEmitter()
        
        var body: some View {
            ClockHand(dimensions, colorTheme: colorTheme, type: .period)
        }
        
        static var defaultDimensions: Dimensions { Dimensions(shape: .roundedRectangle(cornerRadius: 3), lengthRatio: 0.95, width: 3, outlineWidth: ClockHandConstants.Defaults.outlineWidth, overhangRatio: 0.25) }
    }
    
    /**
     Used to draw the basic shape of a clock hand
     */
    struct Positioner: View {
        
        private var shape: Shape
        private var lengthRatio: CGFloat
        private var width: CGFloat
        private var overhangRatio: CGFloat
        private var color: Color?
        private var outlineColor: Color?
        private var outlineWidth: CGFloat
        
        private let ratioRange: ClosedRange<CGFloat> = 0...1.0
        
        init(
            shape: Shape,
            lengthRatio: CGFloat = 1.0,
            width: CGFloat = 4,
            overhangRatio: CGFloat = 0.1,
            color: Color? = nil,
            outlineColor: Color? = nil,
            outlineWidth: CGFloat = 1
        ) {
            self.shape = shape
            self.lengthRatio = limit(lengthRatio, to: ratioRange)
            self.width = width
            self.overhangRatio = limit(overhangRatio, to: ratioRange)
            self.color = color
            self.outlineColor = outlineColor
            self.outlineWidth = outlineWidth
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
            return ZStack {
                shape.roundedRectangle.map { roundedRectangle in
                    StrokedShape(foreground: color, outlineColor: outlineColor, outlineWidth: outlineWidth) { roundedRectangle }
                }
                shape.rectangle.map { rectangle in
                    StrokedShape(foreground: color, outlineColor: outlineColor, outlineWidth: outlineWidth) { rectangle }
                }
                shape.oval.map { oval in
                    StrokedShape(foreground: color, outlineColor: outlineColor, outlineWidth: outlineWidth) { oval }
                }
            }
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
    
    enum Shape {
        case roundedRectangle(cornerRadius: CGFloat, style: RoundedCornerStyle = .circular)
        case rectangle
        case oval
        
        var roundedRectangle: RoundedRectangle? {
            switch self {
            case .roundedRectangle(cornerRadius: let radius, style: let style):
                return RoundedRectangle(cornerRadius: radius, style: style)
            default:
                return nil
            }
        }
        
        var rectangle: Rectangle? {
            switch self {
            case .rectangle:
                return Rectangle()
            default:
                return nil
            }
        }
        
        var oval: Ellipse? {
            switch self {
            case .oval:
                return Ellipse()
            default:
                return nil
            }
        }
    }
}

/// Holds a few static constants used for clock hand rotation calculations
struct ClockHandConstants {
    struct Defaults {
        static let outlineWidth: CGFloat = 1
        static let overhangRatio: CGFloat = 0.1
    }
    
    struct Rotation {
        static let periodDelta: Double = 55
        static var periodOffset: Angle { Angle(degrees:  -periodDelta / 2) }
        
        static let tickTockDelta: Double = 15
        static var tickTockOffset: Angle { Angle(degrees:  -tickTockDelta / 2) }
    }
}
