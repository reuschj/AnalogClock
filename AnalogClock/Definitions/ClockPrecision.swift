//
//  ClockPrecision.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/17/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import Foundation

enum ClockPrecision: TimeInterval {
    typealias RawValue = TimeInterval
    
    case low = 1.0
    case medium = 0.1
    case high = 0.05
    case veryHigh = 0.01
}
