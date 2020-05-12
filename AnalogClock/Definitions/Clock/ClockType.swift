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
enum ClockType: Int {
    case twelveHour = 12
    case twentyFourHour = 24
    case decimal = 10
}
