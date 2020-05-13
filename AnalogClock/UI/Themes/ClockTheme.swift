//
//  ClockTheme.swift
//  AnalogClock
//
//  Created by Justin Reusch on 5/12/20.
//  Copyright © 2020 Justin Reusch. All rights reserved.
//

import SwiftUI

struct ThemeColor {
    var light: Color
    var dark: Color
    
    enum Variation {
        case light(Color)
        case dark(Color)
    }
}

struct AnalogClockColorTheme {
    var appBackground: ThemeColor = ThemeColor(light: .white, dark: .black)
    var clockBackground: ThemeColor? = nil
    var clockOutline: ThemeColor? = ThemeColor(light: .black, dark: .white)
    var clockNumbers: ThemeColor = ThemeColor(light: .black, dark: .white)
    var clockMajorTicks: ThemeColor? = ThemeColor(light: .black, dark: .white)
    var clockMinorTicks: ThemeColor? = ThemeColor(light: .black, dark: .white)
    var hourHand: ThemeColor = ThemeColor(light: .gray, dark: .gray)
    var minuteHand: ThemeColor = ThemeColor(light: .gray, dark: .gray)
    var secondHand: ThemeColor = ThemeColor(light: .gray, dark: .gray)
    var periodHand: ThemeColor = ThemeColor(light: .gray, dark: .gray)
    var periodText: ThemeColor = ThemeColor(light: .gray, dark: .gray)
    var pendulum: ThemeColor = ThemeColor(light: .gray, dark: .gray)
}

struct DigitalClockColorTheme {
    var appBackground: ThemeColor = ThemeColor(light: .white, dark: .black)
    var clockBackground: ThemeColor? = nil
    var clockOutline: ThemeColor? = ThemeColor(light: .black, dark: .white)
    var clockNumbers: ThemeColor = ThemeColor(light: .black, dark: .white)
    var clockMajorTicks: ThemeColor? = ThemeColor(light: .black, dark: .white)
    var clockMinorTicks: ThemeColor? = ThemeColor(light: .black, dark: .white)
}

struct ClockTheme {
    
}
