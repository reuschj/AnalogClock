//
//  ClockPrecision.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/17/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import Foundation
import DecimalTime

/// 1 update per second
fileprivate let lowInterval: TimeInterval = 1.0

/// 1 update per second
fileprivate let lowDecimalInterval: TimeInterval = 1.0.timeInterval

/// 23.967 updates per second
fileprivate let mediumInterval: TimeInterval = 0.04170837504

/// 29.97 updates per second
fileprivate let highInterval: TimeInterval = 0.03336670003

/// 59.94 updates per second
fileprivate let veryHighInterval: TimeInterval = 0.01668335002

/// Enum of clock precision options
enum ClockPrecision: Comparable, Equatable, Hashable, CustomStringConvertible {
            
    // Presets -------------- /
    
    /// 1 update per second (defined by clock type)
    case low
    
    /// 23.967 updates per second
    case medium
    
    /// 29.97 updates per second
    case high
    
    /// 59.94 updates per second
    case veryHigh
    
    // Custom  -------------- /
    
    /// Takes a custom interval input
    case custom(interval: TimeInterval = 1.0)
    
    /// Gets time interval for precision
    var timeInterval: TimeInterval {
        switch self {
        case .low:
            return lowInterval
        case .medium:
            return mediumInterval
        case .high:
            return highInterval
        case .veryHigh:
            return veryHighInterval
        case .custom(interval: let interval):
            return interval
        }
    }
    
    /// Gets decimal time interval for precision
    var decimalTimeInterval: DecimalTimeInterval {
        switch self {
        case .low:
            return 1.0
        default:
            return self.timeInterval.decimalTimeInterval
        }
    }
    
    /**
     Gives an time interval for updates based on clock type
     - Parameter clockType: Clock type (12-hour, 24-hour or decimal)
     */
    func getUpdateInterval(for clockType: ClockType = .twelveHour) -> TimeInterval {
        switch clockType {
        case .twelveHour, .twentyFourHour:
            return self.timeInterval
        case .decimal:
            switch self {
            case .low:
                return self.decimalTimeInterval.timeInterval
            default:
                return self.timeInterval
            }
        }
    }
    
    /**
    Looks up clock precision case based on given interval. Returns `nil` if no nearby value is found.
    - Parameter interval: A time interval to look up in seconds
    */
    static func getPrecision(from interval: TimeInterval) -> ClockPrecision {
        switch interval {
        case lowInterval, lowDecimalInterval:
            return .low
        case mediumInterval:
            return .medium
        case highInterval:
            return .high
        case veryHighInterval:
            return .veryHigh
        default:
            return .custom(interval: interval)
        }
    }
    
    /// Function to compare two clock precisions
    static func <(lhs: ClockPrecision, rhs: ClockPrecision) -> Bool {
        lhs.timeInterval > rhs.timeInterval
    }
    
    /// Function to test equality of two clock precisions
    static func ==(lhs: ClockPrecision, rhs: ClockPrecision) -> Bool {
        lhs.timeInterval == rhs.timeInterval
    }
    
    /// String description
    var description: String {
        var type: String
        switch self {
        case .low:
            type = strings.low
        case .medium:
            type = strings.medium
        case .high:
            type = strings.high
        case .veryHigh:
            type = "Very High"
        case .custom(interval: let interval):
            type = "Custom(\(interval) seconds)"
        }
        return "ClockPrecision(\(type))"
    }
}
