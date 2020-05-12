//
//  ClockHandType.swift
//  AnalogClock
//
//  Created by Justin Reusch on 2/12/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import Foundation
import TimeKeeper

/// Enum of  bases for minute or second clock hand
enum ClockHandBase: Double {
    case standard = 60
    case decimal = 100
}

/// Enum of  bases for hour clock hand
enum HourHandBase: Double {
    case twelve = 12
    case twentyFour = 24
    case decimal = 10
}

/// Enum holding types of clock hands
enum ClockHandType {
    case hour(base: HourHandBase = .twelve)
    case minute(base: ClockHandBase = .standard)
    case second(base: ClockHandBase = .standard, precise: Bool = false)
    case period
    case tickTock
    
    /**
    Gets current time string for the hand type from the `TimeKeeper` instance
     - Parameter time: The current time to pull from
     */
    func getCurrentTime(fromTime time: TimeKeeper?) -> String? {
        guard let time = time else { return nil }
        switch self {
        case .hour(let base):
            switch base {
            case .twelve: return time.hour12String
            case .twentyFour: return time.hour24String
            case .decimal: return time.hourDecimalString
            }
        case .minute(let base):
            switch base {
            case .standard: return time.paddedMinute
            case .decimal: return time.paddedDecimalMinute
            }
        case .second(let base, let precise):
            switch base {
            case .standard: return precise ? time.paddedPreciseSecond : time.paddedSecond
            case .decimal: return precise ? time.paddedPreciseDecimalSecond : time.paddedDecimalSecond
            }
        case .period:
            guard let period = time.period else { return nil }
            return period.rawValue
        case .tickTock:
            guard let tickTock = time.tickTock else { return nil }
            return tickTock.rawValue
        }
    }
}
