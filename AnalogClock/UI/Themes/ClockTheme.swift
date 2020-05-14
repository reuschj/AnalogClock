//
//  ClockTheme.swift
//  AnalogClock
//
//  Created by Justin Reusch on 5/12/20.
//  Copyright © 2020 Justin Reusch. All rights reserved.
//

import SwiftUI

struct UIScale {
    
    var percent: CGFloat = 1
    
    var scaleTo: ScaleBase = .screenWidth
    
    var flexFont: FlexFont { FlexFont(flexFontSize) }
    var flexFontSize: FlexFontSize { percent * 100 }
    
    init(_ percent: CGFloat, of scaleBase: ScaleBase = .screenWidth) {
        self.percent = percent
        self.scaleTo = scaleBase
    }
    
    init(oneOver denominator: CGFloat, of scaleBase: ScaleBase = .screenWidth) {
        let percent: CGFloat = 1 / denominator
        self.init(percent, of: scaleBase)
    }
    
    init(flexFont: FlexFont, of scaleBase: ScaleBase = .screenWidth) {
        self.init(flexFont.percent, of: scaleBase)
    }
    
    init(fontSize: FlexFontSize, of scaleBase: ScaleBase = .screenWidth) {
        self.init((fontSize / 100), of: scaleBase)
    }
    
    enum ScaleBase {
        case screenWidth
        case screenHeight
        case clockDiameter
        case clockRadius
    }
    
    /// A font size that is scaled based on it's container. Should read as a percentage of font height the overall container.
    typealias FlexFontSize = CGFloat
    
    struct FlexFont {
        var size: FlexFontSize = 10
        var percent: CGFloat { size / 100 }
        
        init(_ size: FlexFontSize = 10) {
            self.size = size
        }
    }
}

struct ThemeColor {
    var light: Color = .primary
    var dark: Color = .primary
    
    init(light: Color = .primary, dark: Color = .primary) {
        self.light = light
        self.dark = dark
    }
    
    init(_ color: Color) {
        self.init(light: color, dark: color)
    }
    
    enum Variation {
        case light(Color)
        case dark(Color)
    }
}

struct AnalogClockColorTheme {
    // Backgrounds
    var appBackground: ThemeColor? = nil
    var clockBackground: ThemeColor? = nil
    // Clock
    var clockOutline: ThemeColor? = ThemeColor()
    var clockNumbers: ThemeColor = ThemeColor()
    var clockMajorTicks: ThemeColor? = ThemeColor()
    var clockMinorTicks: ThemeColor? = ThemeColor()
    // Hands
    var hourHand: ThemeColor = ThemeColor()
    var minuteHand: ThemeColor = ThemeColor()
    var secondHand: ThemeColor = ThemeColor()
    // Period hand
    var periodHand: ThemeColor = ThemeColor()
    var periodText: ThemeColor = ThemeColor(.gray)
    // Tick tock pendulum
    var pendulum: ThemeColor = ThemeColor(.gray)
}

struct ClockFont {
    var fontName: String?
    var scale: UIScale?
    var font: Font
    
//    init(fontName: String, scale: UIScale) {
//        self.fontName = fontName
//        self.scale = scale
//        self.font = Font.custom(fontName, size: <#T##CGFloat#>)
//    }
}

struct DigitalClockColorTheme {
    var timeDigits: ThemeColor = ThemeColor()
    var timeSeparators: ThemeColor = ThemeColor(.gray)
    var dateText: ThemeColor = ThemeColor()
}

struct AnalogClockTheme {
    var colors: AnalogClockColorTheme = AnalogClockColorTheme()
    var clockNumbers: ClockFont
    var periodText: ClockFont
}

struct DigitalClockTheme {
    var colors: DigitalClockColorTheme = DigitalClockColorTheme()
    var timeDigits: ClockFont
    var timeSeparators: ClockFont
    var dateText: ClockFont
}

struct ClockTheme {
    var analog: AnalogClockTheme
    var digital: DigitalClockTheme
}
