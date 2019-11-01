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
    
    case low = 1.0
    case medium = 0.1
    case high = 0.05
    case veryHigh = 0.01
    
    static func getPrecision(from interval: TimeInterval) -> ClockPrecision? {
        var matchedCase: ClockPrecision? = nil
        let _ = ClockPrecision.allCases.map {
            if $0.rawValue == interval {
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
