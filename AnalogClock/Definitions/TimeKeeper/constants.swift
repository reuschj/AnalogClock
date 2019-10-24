//
//  constants.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/3/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import Foundation

/**
 Default time between clock ticks (in seconds)
 */
public let defaultTickInterval: TimeInterval = TimeInterval(exactly: 1.0) ?? 1.0

/**
 Strings for month names
 */
let monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "October", "November", "December"]
let shortMonthNames = ["Jan.", "Feb.", "March", "April", "May", "June", "July", "Aug.", "Oct.", "Nov.", "Dec."]

/**
 Strings for week names
 */
let weekNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
let shortWeekNames = ["Sun.", "Mon.", "Tues.", "Wed.", "Thur.", "Fri.", "Sat."]
