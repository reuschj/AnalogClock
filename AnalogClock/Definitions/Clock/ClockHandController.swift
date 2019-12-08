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
    
    /// Computed values for various clock hands
    var hour24: Double? { getRotation(for: .twentyFourHour)}
    var hour: Double? { getRotation(for: .hour)}
    var minute: Double? { getRotation(for: .minute)}
    var second: Double? { getRotation(for: .second)}
    var preciseSecond: Double? { getRotation(for: .preciseSecond)}
    var period: Double? { getRotation(for: .period)}
    var tickTock: Double? { getRotation(for: .tickTock)}
    var tickTockPendulum: Double? { getRotation(for: .tickTockPendulum)}
    
    /**
    Gets rotation for desired clock hand type (enum of `ClockHandType`)
     - Parameters:
        - type: The type of clock, 12-hour or 24-hour
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
     - Parameters:
        - degrees: The value in degrees
     */
    private func convertToRadians(from degrees: Double?) -> Double? {
        guard let rotationInDegrees = degrees else { return nil }
        return rotationInDegrees * Double.pi / 180
    }
    
    /// Full circle in degrees
    private let fullCircle: Double = 360
    
    /**
    Gets rotation in degrees  for desired clock hand type (enum of `ClockHandType`)
     - Parameters:
        - type: The type of clock, 12-hour or 24-hour
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
        // These are with fractions added from smaller increments
        let nanoseconds = Double(nanosecond)
        let seconds = Double(second)
        let percentOfSecond = nanoseconds / 1_000_000_000
        let preciseSeconds = Double(second) + percentOfSecond
        let minutes = Double(minute) + preciseSeconds / 60
        let hours = Double(hour) + minutes / 60
        let hours24 = Double(hour24) + minutes / 60
        let period12: Double = hours / 12
        let period24: Double = hours24 / 24
        // Return the final calculation depending on the type
        switch type {
        case .twentyFourHour:
            return (period24 * fullCircle).truncatingRemainder(dividingBy: fullCircle)
        case .hour:
            return (period12 * fullCircle).truncatingRemainder(dividingBy: fullCircle)
        case .minute:
            return ((minutes / 60) * fullCircle).truncatingRemainder(dividingBy: fullCircle)
        case .second:
            return ((seconds / 60) * 360).truncatingRemainder(dividingBy: fullCircle)
        case .preciseSecond:
            return ((preciseSeconds / 60) * 360).truncatingRemainder(dividingBy: fullCircle)
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
        case.tickTockPendulum:
            switch tickTock {
            case .tock:
                return 1 - percentOfSecond
            default:
                return 0 + percentOfSecond
            }
        }
    }
}
