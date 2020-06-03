//
//  StrokedShape.swift
//  AnalogClock
//
//  Created by Justin Reusch on 5/30/20.
//  Copyright © 2020 Justin Reusch. All rights reserved.
//

import SwiftUI

/// A convenience wrapper to allow you to set both a foreground color and stroke.
struct StrokedShape<ShapeContent>: View where ShapeContent: Shape {
    
    /// Foreground or fill color for the shape
    var foreground: Color?
    
    /// Outline/stroke color
    var outlineColor: Color?
    
    /// Width/thickness of the outline/stroke
    var outlineWidth: CGFloat = 1
    
    /// View builder that produces a shape
    var shape: () -> ShapeContent
    
    // Initializer ---------------------------- /
    
    /**
     Inits with percentage and scale
     - Parameter foreground: Foreground or fill color for the shape
     - Parameter outlineColor: Outline/stroke color
     - Parameter outlineWidth: Width/thickness of the outline/stroke
     - Parameter shape: View builder that produces a shape
     */
    @inlinable init(
        foreground: Color? = nil,
        outlineColor: Color? = nil,
        outlineWidth: CGFloat = 1,
        @ViewBuilder shape: @escaping () -> ShapeContent
    ) {
        self.foreground = foreground
        self.outlineColor = outlineColor
        self.outlineWidth = outlineWidth
        self.shape = shape
    }
    
    // Body ---------------------------- /
    
    var body: some View {
        let shape = self.shape()
        return VStack {
            shape
                .foregroundColor(foreground)
                .overlay(outlineColor.map { shape.stroke($0, lineWidth: outlineWidth) })
        }
    }
}
