//
//  UIAspectRatio.swift
//  AnalogClock
//
//  Created by Justin Reusch on 4/5/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import UIKit

typealias WidthHeightRatio = (width: CGFloat, height: CGFloat)

// Holds an aspect ratio to use for UI elements
struct UIAspectRatio: CustomStringConvertible {
    
    var ratio: WidthHeightRatio
    
    var description: String {
        return "\(ratio.width) : \(ratio.height) (width : height)"
    }
    
    var widthToHeight: CGFloat {
        return ratio.width / ratio.height
    }
    
    var heightToWidth: CGFloat {
        return ratio.height / ratio.width
    }
    
    // Initializers
    
    init(w: CGFloat, h: CGFloat) {
        ratio = reduceRatio(ofFloatingPoints: w, and: h) as! WidthHeightRatio
    }
    
    init(w: Double, h: Double) {
        let reducedRatio = reduceRatio(ofFloatingPoints: w, and: h)
        ratio = (CGFloat(reducedRatio.a), CGFloat(reducedRatio.b))
    }
    
    init(w: Int, h: Int) {
        let reducedRatio = reduceRatio(ofIntegers: w, and: h)
        ratio = (CGFloat(reducedRatio.a), CGFloat(reducedRatio.b))
    }
    
    // Get a width from known height
    
    func getWidth(fromHeight height: CGFloat) -> CGFloat {
        return widthToHeight * ratio.height
    }
    
    func getWidth(fromHeight height: Double) -> CGFloat {
        return widthToHeight * CGFloat(height)
    }
    
    func getWidth(fromHeight height: Int) -> CGFloat {
        return widthToHeight * CGFloat(height)
    }
    
    // Get a width from known height
    
    func getHeight(fromWidth width: CGFloat) -> CGFloat {
        return heightToWidth * width
    }
    
    func getHeight(fromWidth width: Double) -> CGFloat {
        return heightToWidth * CGFloat(width)
    }
    
    func getHeight(fromWidth width: Int) -> CGFloat {
        return heightToWidth * CGFloat(width)
    }
}
