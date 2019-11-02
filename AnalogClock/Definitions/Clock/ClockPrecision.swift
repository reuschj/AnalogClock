//
//  ClockPrecision.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/17/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import Foundation

enum ClockPrecision: TimeInterval, CaseIterable, Comparable, Equatable {
    
    typealias RawValue = TimeInterval
    
    /// 1 update per second
    case low = 1.0
    
    /// 23.967 updates per second
    case medium = 0.04170837504
    
    /// 29.97 updates per second
    case high = 0.03336670003
    
    /// 59.94 updates per second
    case veryHigh = 0.01668335002
    
    /**
     Looks up clock precision case based on given interval. Returns `nil` if no nearby value is found.
        - Parameters:
            - interval: A time interval to look up in seconds
     */
    static func getPrecision(from interval: TimeInterval) -> ClockPrecision? {
        var matchedCase: ClockPrecision? = nil
        let _ = ClockPrecision.allCases.map {
            let rounded = { Int(round($0 * 100)) }
            if rounded($0.rawValue) == rounded(interval) {
                matchedCase = $0
            }
        }
        return matchedCase
    }
    
    /// Function to compare two clock precisions
    static func < (lhs: ClockPrecision, rhs: ClockPrecision) -> Bool {
        lhs.rawValue > rhs.rawValue
    }
}
