//
//  utilities.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/3/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import Foundation

/**
 Pad time unit for output to two digits (1 to 01, etc.) as `String`
 - Parameters:
    - unPadded: The numeric value to pad
 */
func padTimeUnit(_ unPadded: Int) -> String {
    return String(format: "%02d", unPadded)
}

