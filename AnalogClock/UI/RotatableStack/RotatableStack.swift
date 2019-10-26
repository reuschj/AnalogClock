//
//  RotatableStack.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/26/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI

/**
 A stack that is  VStack when in portrait and HStack in landscape
 */
struct RotatableStack<Content>: View where Content : View {
    
    var content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    private func getOrientation(from geometry: GeometryProxy) -> Orientation {
        geometry.size.width > geometry.size.height ? .landscape : .portrait
    }
    
    var body: some View {
        GeometryReader { geometry in
            if self.getOrientation(from: geometry) == .portrait {
                VStack {
                    self.content
                }
            } else {
                HStack {
                    self.content
                }
            }
        }
    }
}
