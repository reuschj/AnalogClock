//
//  limit.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/6/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import Foundation

/**
 Limits a value to a closed range
 */
func limit<T>(_ value: T, to range: ClosedRange<T>) -> T where T: Comparable {
    if value < range.lowerBound {
        return range.lowerBound
    } else if value > range.upperBound {
        return range.upperBound
    } else {
        return value
    }
}
