//
//  ClockType.swift
//  AnalogClock
//
//  Created by Justin Reusch on 3/18/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import Foundation

/**
 Enum for types of clocks, 12-hour, 24-hour or decimal
 */
enum ClockType: Int, CustomStringConvertible {
    
    case twelveHour = 12
    case twentyFourHour = 24
    case decimal = 10
    
    /// The amount of hours making up one full rotation of the clock
    var base: Int { self.rawValue }
    
    /// String description
    var description: String {
        var type: String
        switch self {
        case .twelveHour:
            type = strings.twelveHour
        case .twentyFourHour:
            type = strings.twentyFourHour
        case .decimal:
            type = strings.decimal
        }
        return "ClockType(\(type))"
    }
    
    /**
     Gets clock type from base
     - Parameter base: The amount of hours making up one full rotation of the clock
     */
    static func getFromBase(base: Int) -> ClockType? {
        switch base {
        case 12:
            return .twelveHour
        case 24:
            return .twentyFourHour
        case 10:
            return .decimal
        default:
            return nil
        }
    }
}
