//
//  limitToRange.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/6/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import Foundation

/**
 Limits a value to a closed range
 */
func limitToRange<T>(_ value: T, range: ClosedRange<T>) -> T where T: Comparable {
    if value < range.lowerBound {
        return range.lowerBound
    } else if value > range.upperBound {
        return range.upperBound
    } else {
        return value
    }
}
