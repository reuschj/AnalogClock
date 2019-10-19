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


class ClockPrecisionEmitter: ObservableObject, Hashable {
    
    var timeEmitter: TimeEmitter?

    @Published var precision: ClockPrecision = .low {
        didSet {
            timeEmitter?.interval = precision.rawValue
        }
    }
    
    init(with timeEmitter: TimeEmitter?, as precision: ClockPrecision = .low) {
        self.timeEmitter = timeEmitter
        self.precision = precision
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.precision.rawValue)
    }
    
    static func == (lhs: ClockPrecisionEmitter, rhs: ClockPrecisionEmitter) -> Bool { lhs.precision == rhs.precision && lhs.timeEmitter?.interval == rhs.timeEmitter?.interval }
}
