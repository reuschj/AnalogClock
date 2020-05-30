//
//  UIScale.swift
//  AnalogClock
//
//  Created by Justin Reusch on 5/30/20.
//  Copyright © 2020 Justin Reusch. All rights reserved.
//

import SwiftUI

/// Holds a scale for a UI element to set size dynamically based on the size of it's container
struct UIScale {
    
    /// Percentage of the container to fill (1 = 100%, 0.5 = 50%)
    var percent: CGFloat = 1
    
    /// Selects the container to scale to
    var scaleTo: ScaleBase = .screenWidth
    
    /// If for a font, gets the flex font size
    var flexFont: FlexFont { FlexFont(flexFontSize) }
    var flexFontSize: FlexFontSize { percent * 100 }
    
    // Initializers ---------------------------- /
    
    /**
     Inits with percentage and scale
     */
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
    
    // Methods ---------------------------- /
    
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
