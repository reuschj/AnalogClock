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
    
    func getSize(within containerSize: CGFloat, limitedTo range: ClosedRange<CGFloat>? = nil) -> CGFloat {
        let scaled = containerSize * percent
        guard let range = range else { return scaled }
        if range.contains(scaled) { return scaled }
        if scaled > range.upperBound { return range.upperBound }
        if scaled < range.upperBound { return range.lowerBound }
        return scaled
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

struct AnalogClockColorTheme {
    // Backgrounds
    var appBackground: Color? = nil
    var clockBackground: Color? = nil
    // Clock
    var clockOutline: Color? = .primary
    var clockNumbers: Color = .primary
    var clockMajorTicks: Color = .primary
    var clockMinorTicks: Color = .primary
    // Hands
    var hourHand: Color = .primary
    var minuteHand: Color = .primary
    var secondHand: Color = .primary
    // Period hand
    var periodHand: Color = .primary
    var periodText: Color = .gray
    // Tick tock pendulum
    var pendulum: Color = .gray
}

protocol ClockFont {
    func getFont(within containerSize: CGFloat, limitedTo range: ClosedRange<CGFloat>?) -> Font
}

struct FixedClockFont: ClockFont {
    var font: Font
    
    init(_ font: Font) {
        self.font = font
    }
    
    func getFont(within containerSize: CGFloat = 0, limitedTo range: ClosedRange<CGFloat>? = nil) -> Font { font }
}

struct FlexClockFont: ClockFont {
    var fontName: String?
    var scale: UIScale
    
    init(name fontName: String? = nil, scale: UIScale) {
        self.fontName = fontName
        self.scale = scale
    }
    
    func getFont(within containerSize: CGFloat, limitedTo range: ClosedRange<CGFloat>? = nil) -> Font {
        let size = scale.getSize(within: containerSize, limitedTo: range)
        guard let fontName = fontName else {
            return .system(size: size)
        }
        return Font.custom(fontName, size: size)
    }
}

struct ClockHandDimensions {
    var lengthRatio: CGFloat = 1
    var width: CGFloat = 4
    var outlineWidth: CGFloat = 0.5
}

struct DigitalClockColorTheme {
    var timeDigits: Color = .primary
    var timeSeparators: Color = .gray
    var dateText: Color = .primary
}

struct AnalogClockTheme {
    var colors: AnalogClockColorTheme = AnalogClockColorTheme()
    var clockOutlineWidth: CGFloat = 1
    var clockNumbers: ClockFont = FixedClockFont(.body)
    var handOverhangRatio: CGFloat = 0.1
    var hourHand: ClockHandDimensions = ClockHandDimensions(lengthRatio: 0.6, width: 6, outlineWidth: 1)
    var minuteHand: ClockHandDimensions = ClockHandDimensions(lengthRatio: 0.84, width: 4, outlineWidth: 1)
    var secondHand: ClockHandDimensions = ClockHandDimensions(lengthRatio: 0.92, width: 3, outlineWidth: 1)
    var periodHand: ClockHandDimensions = ClockHandDimensions(lengthRatio: 0.95, width: 3, outlineWidth: 1)
    var periodText: ClockFont = FixedClockFont(.caption)
}

struct DigitalClockTheme {
    var colors: DigitalClockColorTheme = DigitalClockColorTheme()
    var timeDigits: ClockFont = FixedClockFont(.title)
    var timeSeparators: ClockFont = FixedClockFont(.title)
    var dateText: ClockFont = FixedClockFont(.body)
}

struct ClockTheme {
    var key: String
    var analog: AnalogClockTheme = AnalogClockTheme()
    var digital: DigitalClockTheme = DigitalClockTheme()
    
    static let defaultTheme = ClockTheme(
        key: "default_theme",
        analog: AnalogClockTheme(
            colors: AnalogClockColorTheme(
                appBackground: nil,
                clockBackground: nil,
                clockOutline: .secondary,
                clockNumbers: .primary,
                clockMajorTicks: .secondary,
                clockMinorTicks: .gray,
                hourHand: .accentColor,
                minuteHand: .primary,
                secondHand: .secondary,
                periodHand: .gray,
                periodText: .primary,
                pendulum: .gray
            ),
            clockOutlineWidth: 2,
            clockNumbers: FlexClockFont(scale: UIScale(oneOver: 22, of: .clockDiameter)),
            handOverhangRatio: 0.1,
            hourHand: ClockHandDimensions(lengthRatio: 0.6, width: 6, outlineWidth: 1),
            minuteHand: ClockHandDimensions(lengthRatio: 0.84, width: 4, outlineWidth: 1),
            secondHand: ClockHandDimensions(lengthRatio: 0.92, width: 3, outlineWidth: 1),
            periodHand: ClockHandDimensions(lengthRatio: 0.95, width: 3, outlineWidth: 1),
            periodText: FlexClockFont(scale: UIScale(oneOver: 30, of: .clockDiameter))
        ),
        digital: DigitalClockTheme(
            colors: DigitalClockColorTheme(
                timeDigits: .primary,
                timeSeparators: .secondary,
                dateText: .secondary
            ),
            timeDigits: FixedClockFont(.title),
            timeSeparators: FixedClockFont(.body),
            dateText: FixedClockFont(.body)
        )
    )
}
