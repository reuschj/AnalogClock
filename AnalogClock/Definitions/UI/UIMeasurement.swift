//
//  UIMeasurement.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/4/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI

/// A measurement for use in the UI that is based on multiples of a set base amount
struct UIMeasurement {
    
    var multiplier: CGFloat
    let base: CGFloat
    
    var value: CGFloat {
        get { base * multiplier }
        set { multiplier = newValue / base }
    }

    init(_ multiplier: CGFloat = 1, base: CGFloat = 8) {
        self.multiplier = multiplier
        self.base = base
    }
}

/// Base presets
let base = [
    UIMeasurement(0).value,
    UIMeasurement(1).value,
    UIMeasurement(2).value,
    UIMeasurement(3).value,
    UIMeasurement(4).value,
    UIMeasurement(5).value,
    UIMeasurement(6).value,
    UIMeasurement(7).value,
    UIMeasurement(8).value,
    UIMeasurement(9).value,
    UIMeasurement(10).value,
    UIMeasurement(11).value,
    UIMeasurement(12).value,
    UIMeasurement(13).value,
    UIMeasurement(14).value,
    UIMeasurement(15).value,
    UIMeasurement(16).value,
    UIMeasurement(17).value,
    UIMeasurement(18).value,
    UIMeasurement(19).value,
    UIMeasurement(20).value,
    UIMeasurement(21).value,
    UIMeasurement(22).value,
    UIMeasurement(23).value,
    UIMeasurement(24).value,
    UIMeasurement(25).value
]
