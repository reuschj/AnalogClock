//
//  ClockHandController.swift
//  AnalogClock
//
//  Created by Justin Reusch on 2/5/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import Foundation
import TimeKeeper

/**
 Enum for types of rotation units a clock hand controller can output to
 */
enum RotationUnit {
    case degrees
    case radians
}

/**
 Gets rotation values for clock hands in degrees or radians
 */
struct ClockHandController: TimeAware {
    
    /// Keeps the current time
    let time: TimeKeeper!
    
    /// Units to output rotation in
    var unit: RotationUnit = .degrees
    
    /// Initializer with time keeper and preferred output units
    init(using time: TimeKeeper, output unit: RotationUnit = .degrees) {
        self.time = time
        self.unit = unit
    }
    
    // Computed values for various clock hands
    var hour24: Double? { getRotation(for: .hour(base: .twentyFour)) }
    var hour: Double? { getRotation(for: .hour(base: .twelve)) }
    var minute: Double? { getRotation(for: .minute(base: .standard)) }
    var second: Double? { getRotation(for: .second(base: .standard, precise: false)) }
    var preciseSecond: Double? { getRotation(for: .second(base: .standard, precise: true)) }
    var period: Double? { getRotation(for: .period)}
    // Decimal clock hands
    var hourDecimal: Double? { getRotation(for: .hour(base: .decimal)) }
    var minuteDecimal: Double? { getRotation(for: .minute(base: .decimal)) }
    var secondDecimal: Double? { getRotation(for: .second(base: .decimal, precise: false)) }
    var preciseSecondDecimal: Double? { getRotation(for: .second(base: .decimal, precise: true)) }
    
    /**
    Gets rotation for desired clock hand type (enum of `ClockHandType`)
    - Parameter type: The type of clock, 12-hour, 24-hour or decimal
    */
    func getRotation(for type: ClockHandType) -> Double? {
        let rotationInDegrees = getRotationInDegrees(for: type)
        switch unit {
        case .radians:
            return convertToRadians(from: rotationInDegrees)
        default:
            return rotationInDegrees
        }
    }
    
    /**
    Converts degrees to radians
    - Parameter degrees: The value in degrees
    */
    private func convertToRadians(from degrees: Double?) -> Double? {
        guard let rotationInDegrees = degrees else { return nil }
        return rotationInDegrees * Double.pi / 180
    }
    
    /// Full circle in degrees
    private let fullCircle: Double = 360
    
    /// Private functions to  use for repetitive calculations
    private func computeRotation<Base: RawRepresentable>(_ wholeAmount: Int, adder: Double? = nil, base: Base) -> Double where Base.RawValue == Double {
        (((Double(wholeAmount) + (adder ?? 0)) / base.rawValue) * fullCircle).truncatingRemainder(dividingBy: fullCircle)
    }
    private func adjustDecimalRotation(_ decimalRotation: Double) -> Double { decimalRotation.truncatingRemainder(dividingBy: fullCircle) }
    
    /**
    Gets rotation in degrees  for desired clock hand type (enum of `ClockHandType`)
    - Parameter type: The type of clock, 12-hour, 24-hour or decimal
    */
    private func getRotationInDegrees(for type: ClockHandType) -> Double? {
        // Unwrap time elements
        guard let hour24 = time.hour24 else { return nil }
        guard let hour = time.hour12 else { return nil }
        guard let minute = time.minute else { return nil }
        guard let second = time.second else { return nil }
        guard let nanosecond = time.nanosecond else { return nil }
        guard let period = time.period else { return nil }
        guard let tickTock = time.tickTock else { return nil }
        // Get hand rotations from decimal time
        let (hourRotationDecimal, minuteRotationDecimal, secondRotationDecimal, _, _) = time.decimalTime?.rotation ?? (hours: 0.0, minutes: 0.0, seconds: 0.0, milliseconds: 0.0, nanoseconds: 0.0)
        // These are with fractions added from smaller increments
        let secondsAdder = Double(nanosecond) / 1_000_000_000
        let preciseSeconds = Double(second) + secondsAdder
        let minutesAdder = preciseSeconds / 60
        let hoursAdder = Double(minute) / 60
        // Return the final calculation depending on the type
        switch type {
            case .hour(let base):
                switch base {
                case .twelve:
                    return computeRotation(hour, adder: hoursAdder, base: base)
                case .twentyFour:
                    return computeRotation(hour24, adder: hoursAdder, base: base)
                case .decimal:
                    return adjustDecimalRotation(hourRotationDecimal)
                }
            case .minute(let base):
                switch base {
                case .standard:
                    return computeRotation(minute, adder: minutesAdder, base: base)
                case .decimal:
                    return adjustDecimalRotation(minuteRotationDecimal)
                }
            case .second(let base, let precise):
                switch base {
                case .standard:
                    return computeRotation(second, adder: precise ? secondsAdder : nil, base: base)
                case .decimal:
                    return adjustDecimalRotation(precise ? secondRotationDecimal : round(secondRotationDecimal))
                }
            case .period:
                switch period {
                    case .pm:
                        return 1
                    default:
                        return 0
            }
            case .tickTock:
                switch tickTock {
                    case .tock:
                        return 1
                    default:
                        return 0
            }
        }
    }
}
