//
//  TimeInterval.swift
//  AnalogClock
//
//  Created by Justin Reusch on 5/12/20.
//  Copyright © 2020 Justin Reusch. All rights reserved.
//

import Foundation
import DecimalTime

extension TimeInterval {
    var decimalTimeInterval: DecimalTimeInterval { self / DecimalTime.conversionRatio }
}
