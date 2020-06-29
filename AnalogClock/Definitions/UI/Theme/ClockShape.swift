//
//  ClockShape.swift
//  AnalogClock
//
//  Created by Justin Reusch on 5/30/20.
//  Copyright © 2020 Justin Reusch. All rights reserved.
//

import SwiftUI

/// An enum of all shapes that can be used for the outline of the clock
enum ClockShape {
    case circle
    case square
    case roundedRectangle(cornerRadius: CGFloat, style: RoundedCornerStyle = .circular)
    
    var circle: Circle? {
        switch self {
        case .circle:
            return Circle()
        default:
            return nil
        }
    }
    
    var square: Rectangle? {
        switch self {
        case .square:
            return Rectangle()
        default:
            return nil
        }
    }
    
    var roundedRectangle: RoundedRectangle? {
        switch self {
        case .roundedRectangle(cornerRadius: let radius, style: let style):
            return RoundedRectangle(cornerRadius: radius, style: style)
        default:
            return nil
        }
    }
}
