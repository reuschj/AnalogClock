//
//  ClockHandType.swift
//  AnalogClock
//
//  Created by Justin Reusch on 2/12/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import Foundation
import TimeKeeper

/**
 Enum holding types of clock hands
 */
enum ClockHandType: String {
    case twentyFourHour
    case hour
    case minute
    case second
    case preciseSecond
    case period
    case tickTock
    
    /**
    Gets current time string for the hand type from the `TimeKeeper` instance
     - Parameters:
        - time: The current time to pull from
     */
    func getCurrentTime(fromTime time: TimeKeeper?) -> String? {
        guard let time = time else { return nil }
        switch self {
        case .twentyFourHour:
            return time.hour24String
        case .hour:
            return time.hour12String
        case .minute:
            return time.paddedMinute
        case .second:
            return time.paddedSecond
        case .preciseSecond:
            return time.paddedPreciseSecond
        case .period:
            guard let period = time.period else { return nil }
            return period.rawValue
        case .tickTock:
            guard let tickTock = time.tickTock else { return nil }
            return tickTock.rawValue
        }
    }
}
