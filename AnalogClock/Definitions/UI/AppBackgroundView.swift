//
//  AppBackgroundView.swift
//  AnalogClock
//
//  Created by Justin Reusch on 5/29/20.
//  Copyright © 2020 Justin Reusch. All rights reserved.
//

import SwiftUI

struct AppBackgroundView<Content, S>: View where Content : View, S: ShapeStyle {
    
    var fill: S = Color.clear as! S
    
    var style: FillStyle = FillStyle()
    
    /// Stores the content function builder
    public var content: () -> Content
    
    /**
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
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(fill)
                .edgesIgnoringSafeArea(.all)
            content()
        }
    }
}
