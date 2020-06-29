//
//  ClockFont.swift
//  AnalogClock
//
//  Created by Justin Reusch on 5/30/20.
//  Copyright © 2020 Justin Reusch. All rights reserved.
//

import SwiftUI
import Percent

/// Defines a font usable for the clock app
protocol ClockFont {
    func getFont(within containerSize: CGFloat, limitedTo range: ClosedRange<CGFloat>?) -> Font
}

/// A clock font with a fixed size
struct FixedClockFont: ClockFont {
    var font: Font
    
    init(_ font: Font) {
        self.font = font
    }
    
    func getFont(within containerSize: CGFloat = 0, limitedTo range: ClosedRange<CGFloat>? = nil) -> Font { font }
}

/// A font the flexes to fill a certain percentage of it's container
struct FlexClockFont: ClockFont {
    var fontName: String?
    var scale: UIPercent
    
    init(name fontName: String? = nil, scale: UIPercent) {
        self.fontName = fontName
        self.scale = scale
    }
    
    func getFontSize(within containerSize: CGFloat, limitedTo range: ClosedRange<CGFloat>? = nil) -> CGFloat {
        scale.resolve(within: containerSize, limitedTo: range)
    }
    
    func getFont(within containerSize: CGFloat, limitedTo range: ClosedRange<CGFloat>? = nil) -> Font {
        let size = getFontSize(within: containerSize, limitedTo: range)
        guard let fontName = fontName else {
            return .system(size: size)
        }
        return Font.custom(fontName, size: size)
    }
}
