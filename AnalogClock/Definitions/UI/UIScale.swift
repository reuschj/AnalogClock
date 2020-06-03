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
     - Parameter percent: Percentage of the container to fill (1 = 100%, 0.5 = 50%)
     - Parameter scaleBase: Selects the container to scale to
     */
    init(_ percent: CGFloat, of scaleBase: ScaleBase = .screenWidth) {
        self.percent = percent
        self.scaleTo = scaleBase
    }
    
    /**
     Inits with percentage and scale
     - Parameter denominator: Denominator of fractional amount of the container to fill (1 = 1/1 = 100%, 2 = 1/2 = 50%, 4 = 1/4 = 25%, etc.)
     - Parameter scaleBase: Selects the container to scale to
     */
    init(oneOver denominator: CGFloat, of scaleBase: ScaleBase = .screenWidth) {
        let percent: CGFloat = 1 / denominator
        self.init(percent, of: scaleBase)
    }
    
    /**
     Inits with a `FlexFont`
     - Parameter flexFont: A font size that is scaled based on it's container.Denominator of fractional amount of the container to fill (1 = 1/1 = 100%, 2 = 1/2 = 50%, 4 = 1/4 = 25%, etc.)
     - Parameter scaleBase: Selects the container to scale to
     */
    init(flexFont: FlexFont, of scaleBase: ScaleBase = .screenWidth) {
        self.init(flexFont.percent, of: scaleBase)
    }
    
    /**
     Inits with a `FlexFontSize`
     - Parameter fontSize: A font size that is scaled based on it's container. Should read as a full number percentage (of 100) of font height the overall container. (10 = 10%)
     - Parameter scaleBase: Selects the container to scale to
     */
    init(fontSize: FlexFontSize, of scaleBase: ScaleBase = .screenWidth) {
        self.init((fontSize / 100), of: scaleBase)
    }
    
    // Methods ---------------------------- /
    
    /**
    Gets the fixed size from the scale within a given container
     - Parameter containerSize: The container size (just the relevant dimension, height or width)
     - Parameter range: A closed range of allowable sizes to constrain to (optional)
     */
    func getSize(within containerSize: CGFloat, limitedTo range: ClosedRange<CGFloat>? = nil) -> CGFloat {
        let scaled = containerSize * percent
        guard let range = range else { return scaled }
        if range.contains(scaled) { return scaled }
        if scaled > range.upperBound { return range.upperBound }
        if scaled < range.upperBound { return range.lowerBound }
        return scaled
    }
    
    /// Enum of containers within the app to scale to
    enum ScaleBase {
        case screenWidth
        case screenHeight
        case clockDiameter
        case clockRadius
    }
    
    /// A font size that is scaled based on it's container. Should read as a full number percentage (of 100) of font height the overall container. (10 = 10%)
    typealias FlexFontSize = CGFloat
    
    /// A font size that is scaled based on it's container.
    struct FlexFont {
        
        /// A font size that is scaled based on it's container. Should read as a full number percentage (of 100) of font height the overall container. (10 = 10%)
        var size: FlexFontSize = 10
        
        /// Calculated `FlexFontSize` as a percentage of 1, rather than 100
        var percent: CGFloat { size / 100 }
        
        // Initializer ---------------------------- /
        
        /**
         - Parameter size: A font size that is scaled based on it's container. Should read as a full number percentage (of 100) of font height the overall container. (10 = 10%)
         */
        init(_ size: FlexFontSize = 10) {
            self.size = size
        }
    }
}
