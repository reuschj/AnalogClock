//
//  StrokedShape.swift
//  AnalogClock
//
//  Created by Justin Reusch on 5/30/20.
//  Copyright © 2020 Justin Reusch. All rights reserved.
//

import SwiftUI

struct StrokedShape<ShapeContent>: View where ShapeContent: Shape {
    var foreground: Color?
    var outlineColor: Color?
    var outlineWidth: CGFloat = 1
    var shape: () -> ShapeContent
    
    @inlinable init(foreground: Color? = nil, outlineColor: Color? = nil, outlineWidth: CGFloat = 1, @ViewBuilder shape: @escaping () -> ShapeContent) {
        self.foreground = foreground
        self.outlineColor = outlineColor
        self.outlineWidth = outlineWidth
        self.shape = shape
    }
    
    var body: some View {
        let shape = self.shape()
        return VStack {
            shape
                .foregroundColor(foreground)
                .overlay(outlineColor.map { shape.stroke($0, lineWidth: outlineWidth) })
        }
    }
}
