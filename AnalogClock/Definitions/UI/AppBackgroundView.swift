//
//  AppBackgroundView.swift
//  AnalogClock
//
//  Created by Justin Reusch on 5/29/20.
//  Copyright © 2020 Justin Reusch. All rights reserved.
//

import SwiftUI

/// Wraps content within a full-screen (edge-to-edge) background
struct AppBackgroundView<Content, S>: View where Content : View, S: ShapeStyle {
    
    /// The fill for the background
    var fill: S = Color.clear as! S
    
    /// The fill style
    var style: FillStyle = FillStyle()
    
    /// Stores the content function builder
    public var content: () -> Content
    
    // Initializer ---------------------------- /
    
    /**
     - Parameter fill: The fill for the background
     - Parameter style: The fill style
     - Parameter content: The view builder content to pass
     */
    @inlinable public init(
        _ fill: S = Color.clear as! S,
        style: FillStyle = FillStyle(),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.fill = fill
        self.style = style
        self.content = content
    }
    
    // Body ---------------------------- /
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(fill)
                .edgesIgnoringSafeArea(.all)
            content()
        }
    }
}
