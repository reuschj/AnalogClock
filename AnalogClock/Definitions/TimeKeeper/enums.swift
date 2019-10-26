//
//  enums.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/3/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import Foundation

/**
 Enum for periods (AM/PM) on a 12-hour clock
 */
public enum Period: String {
    case am
    case pm
}

/**
 Enum holding tick tock states (left/right of clock pendulum)
 */
public enum TickTock: String {
    case tick
    case tock
}
