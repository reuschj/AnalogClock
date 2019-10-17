//
//  DigitalClockComponents.swift
//  AnalogClock
//
//  Created by Justin Reusch on 10/16/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import SwiftUI

struct DigitalClockSeperator: View {
    
    var width: CGFloat = UIMeasurement(0.5).value
    
    var color: Color = .secondary
    
    var body: some View {
        HStack {
            Spacer().fixedSize().frame(width: width / 2)
            Text(":").foregroundColor(color)
            Spacer().fixedSize().frame(width: width / 2)
        }
    }
}

struct TimeTextBlock: View {
    
    var text: String?
    
    var color: Color = .primary
    
    var body: some View {
        Text(text ?? "")
            .font(.title)
            .foregroundColor(color)
    }
}

struct TimeNumberBlock: View {
    
    var number: Int?
    
    var color: Color = .primary
    
    var body: some View {
        TimeTextBlock(text: "\(number ?? 0)", color: color)
    }
}
